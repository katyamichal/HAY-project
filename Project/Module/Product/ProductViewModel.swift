//
//  ProductViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.07.2024.
//

import UIKit

protocol IProductViewModel: AnyObject {
    var productName: String { get }
    var description: String { get }
    var images: [UIImage] { get }
    var productInfo: [[String: String]] { get }
    var isFavourite: Bool { get }
    var productId: Int { get }
    var buttonTitle: String { get }
    
    func setupView(with view: IProductView)
    func fetchData()
    func goBack()
    func unsubscribe(observer: IObserver)
}

final class ProductViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IProductView?
    
    private let service: HayServiceable
    private let likeManager = LikeButtonManager.shared
    
    private let hayEndpoint: HayEndpoints
    let productId: Int
    private let categoryName: String
    
    private var viewData: Observable<ProductViewData>
    private var loadingError = Observable<String>()
    

    // MARK: - Inits
    
    init(service: HayServiceable, coordinator: Coordinator, hayEndpoint: HayEndpoints, categoryName: String, productId: Int) {
        self.service = service
        self.coordinator = coordinator
        self.hayEndpoint = hayEndpoint
        self.categoryName = categoryName
        self.productId = productId
        self.viewData = Observable<ProductViewData>()
    }
    
    deinit {
        print("SingleProductViewModel deinit")
    }
    
    // MARK: - Fetching Data
    
    func fetchData() {
        fetchDataFromServer()
    }
    
    // MARK: - Observable methods

    func subscribe(observer: IObserver) {
        viewData.subscribe(observer: observer)
        loadingError.subscribe(observer: observer)
    }
    
    func unsubscribe(observer: IObserver) {
        viewData.unsubscribe(observer: observer)
        loadingError.unsubscribe(observer: observer)
    }
}

// MARK: - ViewModel Protocol

extension ProductViewModel: IProductViewModel {
    var buttonTitle: String {
        return Constants.LabelTitles.addBasketButtonName
    }
    
    var isFavourite: Bool {
        if likeManager.favouriteProducts.value?.products.first(where: { $0.id == viewData.value?.id }) != nil {
            return true
        }
        return false
    }
    
    var images: [UIImage] {
        guard let product = viewData.value else { return [] }
        return  (product.imageCollection + [product.image]).map { imageName in
            UIImage(named: imageName) ?? UIImage()
        }
    }
    
    var productInfo: [[String: String]]  {
        [material, colour, size, price]
    }
    
    var description: String {
        guard let product = viewData.value else { return emptyData }
        return  product.description
    }
    
    var productName: String {
        guard let product = viewData.value else { return emptyData }
        return product.productName.uppercased()
    }
    
    func setupView(with view: IProductView) {
        self.view = view
        self.view?.viewIsSetUp()
    }
    
    func goBack() {
        view?.unsubscribe()
        (coordinator as? ProductCoordinator)?.finish()
    }
}

extension ProductViewModel: ILikeButton {
    func changeStatus(with id: Int) {
        defer { view?.updateView(with: isFavourite, and: productId) }
        guard let product = viewData.value else { return }
        likeManager.changeProductStatus(with: product)
    }
}

private extension ProductViewModel {
    
    var emptyData: String {
        Constants.EmptyData.noData
    }
    
    var material: [String: String] {
        guard let product = viewData.value else { return [Constants.ProductModuleTitles.material : emptyData] }
        return [Constants.ProductModuleTitles.material.uppercased(): product.material.lowercased()]
    }
    
    var size: [String: String] {
        guard let product = viewData.value else { return [Constants.ProductModuleTitles.size: emptyData] }
        return [Constants.ProductModuleTitles.size.uppercased(): product.size.lowercased()]
    }
    
    var colour: [String: String] {
        guard let product = viewData.value else { return [Constants.ProductModuleTitles.colour: emptyData] }
        return  [Constants.ProductModuleTitles.colour.uppercased(): product.colour.lowercased()]
    }
    
    var price: [String: String] {
        guard let product = viewData.value else { return [Constants.ProductModuleTitles.price: emptyData] }
        return [Constants.ProductModuleTitles.price.uppercased(): "£\(product.price)".lowercased()]
    }
    
    func fetchDataFromServer() {
        switch hayEndpoint {
        case .categories:
            Task {
                do {
                    async let categoriesResponse = try service.getCategories()
                    
                    let categories = try await categoriesResponse.categories
                    guard let category = categories.first(where: { $0.categoryName == categoryName }),
                          let product = category.products.first(where: { $0.id == productId })
                    else {
                        self.loadingError.value = Constants.LoadingMessage.unknown
                        return
                    }
                    self.viewData.value = ProductViewData(product: product)
                } catch {
                    self.loadingError.value = error.localizedDescription
                }
            }
        case .designers:
            Task {
                do {
                    async let categoriesResponse = try service.getDesigners()
                    
                    let designers = try await categoriesResponse.designers
                    
                    guard let designer = designers.first(where: { $0.designerName == categoryName }),
                          let product = designer.products.first(where: { $0.id == productId })
                    else {
                        self.loadingError.value = Constants.LoadingMessage.unknown
                        return
                    }
                    self.viewData.value = ProductViewData(product: product)
                } catch {
                    self.loadingError.value = error.localizedDescription
                }
            }
        case .inspiration:
            Task {
                do {
                    async let categoriesResponse = try service.getInspiration()
                    
                    let inspiration = try await categoriesResponse.inspiration
                    guard let inspirationFeed = inspiration.first(where: { $0.collectionName == categoryName }),
                          let product = inspirationFeed.products.first(where: { $0.id == productId })
                    else {
                        self.loadingError.value = Constants.LoadingMessage.unknown
                        return
                    }
                    self.viewData.value = ProductViewData(product: product)
                } catch {
                    self.loadingError.value = error.localizedDescription
                }
            }
        }
    }
}
