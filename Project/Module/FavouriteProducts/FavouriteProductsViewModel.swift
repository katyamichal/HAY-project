//
//  FavouriteProductsViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import Foundation

protocol IFavouriteProductsViewModel: AnyObject {
    func setupView(with view: IFavouriteProductsView)
}

final class FavouriteProductsViewModel {
    
    private weak var coordinator: IFavouriteCoordinator?
    private weak var view: IFavouriteProductsView?
    private let dataService: any ICoreDataService
   // private var viewData: Observable<>
    
    
    init(coordinator: IFavouriteCoordinator, dataService: any ICoreDataService) {
        self.coordinator = coordinator
        self.dataService = dataService
    }
    
//    func suubscribe(observer: IObserver) {
//        viewData.
//    }
}

extension FavouriteProductsViewModel: IFavouriteProductsViewModel {
    func setupView(with view: IFavouriteProductsView) {
        self.view = view
    }
}
