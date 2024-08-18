//
//  DesignerDetailsView.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import UIKit

final class DesignerDetailsView: UIView {

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
        print("DesignerDetailsView deinit")
    }
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DesignerInfoCollectionCell.self, forCellWithReuseIdentifier: DesignerInfoCollectionCell.reuseIndentifier)
        return collectionView
    }()
    
    // MARK: - Public
    
    func setupDataSource(_ dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
    }
    
    func updateView() {
        collectionView.reloadData()
    }
}

private extension DesignerDetailsView {
    func setupView() {
        backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    // MARK: - Collection Compositional Layout

    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let sectionType = DesignerDetailsSection.allCases[sectionIndex]
            switch sectionType {
            case .designerInfo: return self.generateDisegnerInfoGroupLayout()
            }
        }, configuration: config)
        return layout
    }
    
    func generateDisegnerInfoGroupLayout() -> NSCollectionLayoutSection? {
        let inset: CGFloat = 24
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset)
        return section
    }
}
