//
//  HayViewModel.swift.
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.

import UIKit

enum ServiceResponse {
    case success
    case failure
}

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

    func setupView(with view: IHayViewController) {
        self.view = view
        self.view?.viewIsSetUp()
    }
    
    func subscribe(observer: IObserver) {
        viewData.subscribe(observer: observer)
        loadingError.subscribe(observer: observer)
    }
    
    // MARK:  Fetching Data
    
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
                self.loadingError.value = getErrorResponse(with: error)
            }
        }
    }
    
    // MARK: - Initializinf TableView modules

    func createCategory(with cell: UITableViewCell, at index: Int) {
        guard let categoryData = viewData.value?.categories[index] else { return }
        (coordinator as? HayCoordinator)?.showCategoryCoordinator(cell: cell, viewData: categoryData)
       // print((coordinator as? HayCoordinator)?.childCoordinators)
    }
    
    func createInspiration(with view: Header) {
        guard let inspiration = viewData.value?.inspiration else { return }
        (coordinator as? HayCoordinator)?.showInspiration(view: view, viewData: inspiration)
    }
    
    func showDesignerDetail(designerId: Int) {
        (coordinator as? HayCoordinator)?.showDesignerDetail(designerId)
    }
}

// MARK: - Private

private extension HayViewModel {
    func getErrorResponse(with requestError: Error) -> String {
        if let error = requestError as? RequestProcessorError {
            return configureKnownResponseError(with: error)
        } else {
            return Constants.LoadingMessage.unknown
        }
    }
    
    func configureKnownResponseError(with type: RequestProcessorError) -> String {
        switch type {
        case .noInternetConnection:
            return Constants.LoadingMessage.noInternetConnection
            
        case .invalidURL, .decodingError, .invalidResponse:
            return Constants.LoadingMessage.failFetchData
            
        case .urlSessionError:
            return Constants.LoadingMessage.urlSessionError
            
        case .serverError:
            return Constants.LoadingMessage.serverError
            
        case .unauthorized, .statusCode(_), .wrongURL(_):
            return Constants.LoadingMessage.unknown
        }
    }
}
