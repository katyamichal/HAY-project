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
    func setupView(with view: IProductView)
    func fetchData()
    func goBack()
    func subscribe(observer: IObserver)
}

final class ProductViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IProductView?
    private let service: HayServiceable
    private let productId: Int
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
}

extension ProductViewModel: IProductViewModel {
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
        (coordinator as? ProductCoordinator)?.finish()
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
