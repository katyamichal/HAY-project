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
    
    private let likeManager = LikeButtonManager.shared
    private let productFetchService: ProductFetchService
    
    private let hayEndpoint: ProductEndpoint
    private let itemId: Int
    let productId: Int
    
    private var viewData: Observable<ProductViewData>
    private var loadingError = Observable<String>()
    
    // MARK: - Inits
    
    init(service: ProductFetchService, coordinator: Coordinator, hayEndpoint: ProductEndpoint, itemId: Int, productId: Int) {
        self.productFetchService = service
        self.coordinator = coordinator
        self.hayEndpoint = hayEndpoint
        self.itemId = itemId
        self.productId = productId
        self.viewData = Observable<ProductViewData>()
    }
    
    deinit {
        print("SingleProductViewModel deinit")
    }
    
    // MARK: - Fetching Data
    
    func fetchData() {
         Task {
             do {
                 if let productViewData = try await productFetchService.fetchProduct(itemId: itemId, productId: productId) {
                     self.viewData.value = productViewData
                 } else {
                     self.loadingError.value = Constants.LoadingMessage.unknown
                 }
             } catch {
                 self.loadingError.value = error.localizedDescription
             }
         }
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

    // MARK: - Like Buttin Managing
    
    var isFavourite: Bool {
        if likeManager.favouriteProducts.value?.products.first(where: { $0.productId == viewData.value?.productId }) != nil {
            return true
        }
        return false
    }
    
    // MARK: - Computed properties for a single product
    
    var description: String {
        guard let product = viewData.value else { return emptyData }
        return  product.description
    }
    
    var productName: String {
        guard let product = viewData.value else { return emptyData }
        return product.productName.uppercased()
    }
    
    var images: [UIImage] {
        guard let product = viewData.value else { return [] }
        return  (product.imageCollection + [product.image]).map { imageName in
            UIImage(named: imageName) ?? UIImage() }
    }
    
    var productInfo: [[String: String]]  {
        [material, colour, size, price]
    }
    
    // MARK: - View Setups
    
    func setupView(with view: IProductView) {
        self.view = view
        self.view?.viewIsSetUp()
    }
    
    var buttonTitle: String {
        return Constants.LabelTitles.addBasketButtonName
    }
    
    // MARK: - Navigation
    
    func goBack() {
        view?.unsubscribe()
        (coordinator as? ProductCoordinator)?.finish()
    }
}

// MARK: - Like Button Delegate

extension ProductViewModel: ILikeButton {
    func changeStatus(with id: Int) {
        defer { view?.updateView(with: isFavourite, and: productId) }
        guard let product = viewData.value else { return }
        likeManager.changeProductStatus(with: product)
    }
}

// MARK: - Private

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
}
