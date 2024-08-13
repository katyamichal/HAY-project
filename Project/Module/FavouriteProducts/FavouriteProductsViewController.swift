//
//  FavouriteProductsViewController.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import UIKit

protocol IFavouriteProductsView: AnyObject {
    func updateView()
}

final class FavouriteProductsViewController: UIViewController {
    private let viewModel: IFavouriteProductsViewModel
    private var favouriteView: FavouriteProductsView { return self.view as! FavouriteProductsView }
    var id: UUID
    
    // MARK: - Inits
    
    init(viewModel: IFavouriteProductsViewModel) {
        self.viewModel = viewModel
        id = UUID()
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
        setupCollectionViewDelegate()
        viewModel.setupView(with: self)
        viewModel.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
}

extension FavouriteProductsViewController: IFavouriteProductsView {
    func updateView() {
        favouriteView.updateCollectionView()
    }
}

// MARK: - UICollectionViewDataSource and Delegate

extension FavouriteProductsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicCollectionViewCell.cellIdentifier, for: indexPath) as? BasicCollectionViewCell else {
           return UICollectionViewCell()
        }
        viewModel.setCurrentProduct(at: indexPath.row)
        cell.update(productName: viewModel.productName, price: viewModel.price, image: viewModel.image)
        return cell
    }
}


extension FavouriteProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension FavouriteProductsViewController: IObserver {
    func update<T>(with value: T) {
        if value is Products {
            viewModel.getData()
        }
    }
}

private extension FavouriteProductsViewController {
    func setupCollectionViewDelegate() {
        favouriteView.setupCollectionViewdelegate(self)
        favouriteView.setupCollectionViewDataSource(self)
    }
}
