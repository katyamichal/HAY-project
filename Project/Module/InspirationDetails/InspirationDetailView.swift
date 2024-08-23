//
//  InspirationDetailView.swift
//  Project
//
//  Created by Catarina Polakowsky on 23.08.2024.
//

import UIKit

final class InspirationDetailView: UIView {
    
    private enum SectionType: CaseIterable {
        case photoGaleryDescription
        case products
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("InspirationDetailView deinit")
    }
    
    // MARK: - UI Element
    private(set) lazy var collectionView: UICollectionView = {
        let layout = createCollectionView()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.register(GaleryCollectionCell.self, forCellWithReuseIdentifier: GaleryCollectionCell.cellIdentifier)
        collection.register(BasicCollectionViewCell.self, forCellWithReuseIdentifier: BasicCollectionViewCell.cellIdentifier)
        return collection
    }()
}

// MARK: - Layout methods
private extension InspirationDetailView {
    func setupView() {
        backgroundColor = Colours.Main.hayBackground
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        addSubview(collectionView)
    }

    func setupConstraints() {
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    func createCollectionView() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex, layoutEnviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let isWideView = layoutEnviroment.container.effectiveContentSize.width > 500

            let sectionLayoutKind = SectionType.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .photoGaleryDescription:
                return self?.createDescriptionLayout(isWide: isWideView)
            case .products:
                return self?.createProductsLayout(isWide: isWideView)
            }
        }, configuration: config)

        return layout
    }

    // MARK:  collection section' layouts

    func createDescriptionLayout(isWide: Bool) -> NSCollectionLayoutSection {
        let height = Constants.Layout.headerHeight + 200
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupFractionalWidth = isWide ? 0.855 : 1.0
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth), heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func createProductsLayout(isWide: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupFractionalWidth = isWide ? 0.855 : 1.0
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(16)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
