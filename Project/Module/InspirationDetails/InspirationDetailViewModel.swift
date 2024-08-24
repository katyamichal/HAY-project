//
//  InspirationDetailViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 23.08.2024.
//

import UIKit

protocol InspirationDetailViewModelProtocol: AnyObject {
    var productCount: Int { get }
    var collectionName: String { get }
    var imageCollection: [UIImage] { get }
    var description: String { get }
    
    func setupView(with view: InspirationDetailViewProtocol)
    func subscribe(_ observer: IObserver)
}

final class InspirationDetailViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: InspirationDetailViewProtocol?
    private let service: HayServiceable
    private let inspirationIndex: Int
    private var viewData: Observable<InspirationDetailViewData>
    private var loadingError = Observable<String>()
    private let likeManager = LikeButtonManager.shared
    // MARK: - Inits
    
    init(service: HayServiceable, coordinator: Coordinator, inspirationIndex: Int) {
        self.service = service
        self.coordinator = coordinator
        self.inspirationIndex = inspirationIndex
        self.viewData = Observable<InspirationDetailViewData>()
    }
    
    deinit {
        print("InspirationDetailViewModel deinit")
    }
    
    func fetchData() {
        Task {
            do {
                async let inspirationResponse = try service.getInspiration()
                let inspiration = try await inspirationResponse.inspiration[inspirationIndex]
                viewData.value = InspirationDetailViewData(with: inspiration)
            }
        }
    }
}

extension InspirationDetailViewModel: InspirationDetailViewModelProtocol {
    func subscribe(_ observer: IObserver) {
        viewData.subscribe(observer: observer)
    }
    
    var imageCollection: [UIImage] {
        return [coverImage] + images
    }
    
    var collectionName: String {
        return viewData.value?.collectionName ?? emptyData
    }
    
    var description: String {
        return viewData.value?.description ?? emptyData
    }
    
    var productCount: Int {
        return viewData.value?.products.count ?? 0
    }
    
    func setupView(with view: InspirationDetailViewProtocol) {
        self.view = view
        fetchData()
    }
}

private extension InspirationDetailViewModel {
    var emptyData: String {
        return "No data"
    }
    
    var coverImage: UIImage {
        return UIImage(named: viewData.value?.coverImage ?? "") ?? UIImage()
    }
    
    var images: [UIImage] {
        return viewData.value?.images.compactMap { UIImage(named: $0) } ?? []
    }
}

