//
//  FavouriteProductsViewController.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import UIKit

protocol IFavouriteProductsView: AnyObject {
    
}

final class FavouriteProductsViewController: UIViewController {
    private let viewModel: IFavouriteProductsViewModel
    private var favouriteView: FavouriteProductsView { return self.view as! FavouriteProductsView }
    
    // MARK: - Inits
    
    init(viewModel: IFavouriteProductsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
       print("FavouriteProductsViewController deinit")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = FavouriteProductsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setupView(with: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
}

extension FavouriteProductsViewController: IFavouriteProductsView {
    
}

// MARK: - UICollectionViewDataSource and Delegate

extension FavouriteProductsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
       // return viewModel
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicCollectionViewCell.cellIdentifier, for: indexPath) as? BasicCollectionViewCell else {
           return UICollectionViewCell()
        }
        return cell
    }
}


extension FavouriteProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
