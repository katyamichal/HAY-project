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
    func goBack()
    func changeFavourite()
}

final class ProductViewModel {
    private weak var coordinator: Coordinator?
    private weak var view: IProductView?
    private var viewData: ProductViewData
    private var isFavourite: Observable<Bool>
    
    // MARK: - Inits

    init(coordinator: Coordinator, product: Product) {
        self.coordinator = coordinator
        self.viewData = ProductViewData(product: product)
        isFavourite = Observable<Bool>(false)
    }
    
    deinit {
        print("SingleProductViewModel deinit")
    }
}

extension ProductViewModel: IProductViewModel {
    
    func changeFavourite() {
        guard let isFavourite = isFavourite.value else { return }
        if isFavourite {
            // coreDataManager.deleteProduct(with: product.id)
        } else {
            // coreDataManager.createProduct(product)
        }
        self.isFavourite.value = !isFavourite
    }
    
    var images: [UIImage] {
        (viewData.product.imageCollection + [viewData.product.image]).map { imageName in
            UIImage(named: imageName) ?? UIImage()
        }
    }
    var productInfo: [[String: String]]  {
        [material, colour, size, price]
    }
    
    var description: String {
        viewData.product.description
    }
    
    var productName: String {
        viewData.product.productName.uppercased()
    }
    
    func setupView(with view: IProductView) {
        self.view = view
    }
    
    func goBack() {
        (coordinator as? ProductCoordinator)?.finish()
    }
}

private extension ProductViewModel {

    var material: [String: String] {
        ["material:".uppercased(): viewData.product.material.lowercased()]
    }
    
    var size: [String: String] {
        ["size".uppercased(): viewData.product.size.lowercased()]
    }
    
    var colour: [String: String] {
        ["colour".uppercased(): viewData.product.colour.lowercased()]
    }
    
    var price: [String: String] {
        ["price".uppercased(): "£\(viewData.product.price)".lowercased()]
    }
}
