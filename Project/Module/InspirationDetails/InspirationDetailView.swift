//
//  InspirationDetailView.swift
//  Project
//
//  Created by Catarina Polakowsky on 23.08.2024.
//

import UIKit

enum InspirationDetailSectionType: CaseIterable {
    case photoGalleryDescription
    case products
}

final class InspirationDetailView: UIView {
    // MARK: - Constants for constraints

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
    
    // MARK: - UI Elements
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityIndicator.center = self.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.isHidden = true
        label.numberOfLines = 0
        label.font = Fonts.Subtitles.defaultFont
        return label
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = createCollectionView()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.isHidden = true
        collection.register(GalleryCollectionCell.self, forCellWithReuseIdentifier: GalleryCollectionCell.cellIdentifier)
        collection.register(BasicCollectionViewCell.self, forCellWithReuseIdentifier: BasicCollectionViewCell.cellIdentifier)
        return collection
    }()
    
    // MARK: - Public methods

    func setupCollectionViewDataSource(with dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
    }
    
    func setupCollectionViewDelegate(with delegate: UICollectionViewDelegate) {
        collectionView.delegate = delegate
    }
    
    func updateView() {
        collectionView.isHidden = false
        loadingIndicator.stopAnimating()
        collectionView.reloadData()
    }
    
    func updateView(with error: String?) {
        loadingIndicator.stopAnimating()
        errorLabel.isHidden = false
        errorLabel.text = error
    }
}

// MARK: - Layout methods
private extension InspirationDetailView {
    func setupView() {
        backgroundColor = Colours.Main.hayBackground
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        addSubview(errorLabel)
        addSubview(loadingIndicator)
        addSubview(collectionView)
    }

    func setupConstraints() {
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    // MARK: - Collection layout
    
    func createCollectionView() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex, layoutEnviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let isWideView = layoutEnviroment.container.effectiveContentSize.width > 500

            let sectionLayoutKind = InspirationDetailSectionType.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .photoGalleryDescription:
                return self?.createDescriptionLayout(isWide: isWideView)
            case .products:
                return self?.createProductsLayout(isWide: isWideView)
            }
        }, configuration: config)

        return layout
    }

    // MARK: Gallery Section

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
