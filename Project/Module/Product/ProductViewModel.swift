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
    
    func setupView(with view: IProductView)
    func fetchData()
    func goBack()
    func unsubscribe(observer: IObserver)
}

final class ProductViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IProductView?
    private let service: HayServiceable
    internal let productId: Int
    private let categoryName: String
    private var viewData: Observable<ProductViewData>
    private var loadingError = Observable<String>()
    private let likeManager = LikeButtonManager.shared
    
    // MARK: - Inits
    
    init(service: HayServiceable, coordinator: Coordinator, categoryName: String, productId: Int) {
        self.service = service
        self.coordinator = coordinator
        self.categoryName = categoryName
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
                async let categoriesResponse = try service.getCategories()
                
                let categories = try await categoriesResponse.categories
                guard let category = categories.first(where: { $0.categoryName == categoryName }),
                      let product = category.products.first(where: { $0.id == productId })
                else {
                    self.loadingError.value = "Couldn't load the product"
                    return
                }
                self.viewData.value = ProductViewData(product: product)
            } catch {
                self.loadingError.value = error.localizedDescription
            }
        }
    }
    
    func subscribe(observer: IObserver) {
        viewData.subscribe(observer: observer)
        loadingError.subscribe(observer: observer)
    }
    
    func unsubscribe(observer: IObserver) {
        viewData.unsubscribe(observer: observer)
        loadingError.unsubscribe(observer: observer)
    }
}

extension ProductViewModel: IProductViewModel {
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
        guard let product = viewData.value else { return "no data" }
        return  product.description
    }
    
    var productName: String {
        guard let product = viewData.value else { return "no data" }
        return product.productName.uppercased()
    }
    
    func setupView(with view: IProductView) {
        self.view = view
        self.view?.getData()
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
    var material: [String: String] {
        guard let product = viewData.value else { return ["material:" : "no data"] }
        return ["material:".uppercased(): product.material.lowercased()]
    }
    
    var size: [String: String] {
        guard let product = viewData.value else { return ["size:" : "no data"] }
        return ["size".uppercased(): product.size.lowercased()]
    }
    
    var colour: [String: String] {
        guard let product = viewData.value else { return ["colour:" : "no data"] }
        return  ["colour".uppercased(): product.colour.lowercased()]
    }
    
    var price: [String: String] {
        guard let product = viewData.value else { return ["price:" : "no data"] }
        return ["price".uppercased(): "£\(product.price)".lowercased()]
    }
}
