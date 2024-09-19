//
//  HayViewModel.swift.
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.

import UIKit

final class HayViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IHayViewController?
    private let service: HayServiceable
    private(set) var viewData: Observable<HayViewData>
    private var loadingError: Observable<String>
    private let likeManager = LikeButtonManager.shared
    
    // MARK: - Init
    
    init(coordinator: Coordinator, service: HayServiceable) {
        self.coordinator = coordinator
        self.service = service
        self.viewData = Observable<HayViewData>()
        self.loadingError = Observable<String>()
    }
    
    deinit {
        print("MainViewModel deinit")
    }
    
    // MARK: - View Setup
    
    func setupView(with view: IHayViewController) {
        self.view = view
        self.view?.viewIsSetUp()
    }
    
    // MARK: - Observable Subscription
    
    func subscribe(observer: IObserver) {
        viewData.subscribe(observer: observer)
        loadingError.subscribe(observer: observer)
    }
    
    // MARK: - Fetching Data
    
    func fetchServerData() {
        Task {
            do {
                async let inspirationResponse = try service.getInspiration()
                async let designersResponse = try service.getDesigners()
                async let categoriesResponse = try service.getCategories()
                
                let inspiration = try await inspirationResponse.inspiration
                let categories = try await categoriesResponse.categories
                let designers = try await designersResponse.designers
                
                self.viewData.value = HayViewData(inspiration: inspiration, categories: categories, designers: designers)
                
            } catch {
                self.loadingError.value = ErrorHandler.getErrorResponse(with: error)
            }
        }
    }
    
    // MARK: - Initializing TableView modules
    
    func createCategory(with cell: CategoryTableCell, at index: Int, with indexPath: IndexPath) {
        guard let categoryData = viewData.value?.categories[index] else { return }
        (coordinator as? HayCoordinator)?.showCategoryCoordinator(cell: cell, at: indexPath, viewData: categoryData)
    }
    
    func createInspiration(with view: Header) {
        guard let inspiration = viewData.value?.inspiration else { return }
        (coordinator as? HayCoordinator)?.showInspiration(view: view, viewData: inspiration)
    }
    
    func createDesigner(with cell: DesignerTableCell, at index: Int, with indexPath: IndexPath) {
        guard let designerData = viewData.value?.designers[index] else { return }
        (coordinator as? HayCoordinator)?.showDesignerModule(cell: cell, at: indexPath, viewData: designerData)
    }
    
    // MARK: - Show Detail methods
    
    func showDesignerDetail(designerId: Int) {
        (coordinator as? HayCoordinator)?.showDesignerDetail(designerId)
    }
}
