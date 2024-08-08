//
//  FavouriteProductsView.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import UIKit

final class FavouriteProductsView: UIView {
    
    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("FavouriteView deinit")
    }
    
    // MARK: - UI Elements

   private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = Colours.Main.hayBackground
        collection.showsVerticalScrollIndicator = false
        collection.register(BasicCollectionViewCell.self, forCellWithReuseIdentifier: BasicCollectionViewCell.cellIdentifier)
        return collection
    }()
    
   private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .light)
        label.textColor = .label
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    // MARK: - Layout

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(16)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // MARK: - Private

    private func updateView() {
        headerLabel.text = "favourite".uppercased()
        collectionView.isHidden = false
        collectionView.reloadData()
    }
}


// MARK: - Setups

private extension FavouriteProductsView {
    func setupView() {
        self.backgroundColor = Colours.Main.hayBackground
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(collectionView)
        addSubview(headerLabel)
        
    }
    
    func setupConstraints() {
        headerLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
