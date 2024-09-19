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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.numberOfLines = 0
        label.font = Fonts.Subtitles.defaultFont
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.isHidden = true
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DesignerInfoCollectionCell.self, forCellWithReuseIdentifier: DesignerInfoCollectionCell.reuseIdentifier)
        collectionView.register(QuoteSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QuoteSupplementaryView.reuseIdentifier)
        collectionView.register(TextCollectionCell.self, forCellWithReuseIdentifier: TextCollectionCell.reuseIdentifier)
        collectionView.register(DesignerCollectionImages.self, forCellWithReuseIdentifier: DesignerCollectionImages.reuseIdentifier)
        collectionView.register(BasicCollectionViewCell.self, forCellWithReuseIdentifier: BasicCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Public
    
    func setupDataSource(_ dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
    }
    
    func setupCollectionDelegate(_ delegate: UICollectionViewDelegate) {
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

private extension DesignerDetailsView {
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
        collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

// MARK: - Collection Compositional Layout

private extension DesignerDetailsView {

    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let sectionType = DesignerDetailsSection.allCases[sectionIndex]
            switch sectionType {
            case .designerInfo: return self.generateDisegnerInfoSectionLayout()
            case .quote1, .quote2: return self.generateQuoteSectionLayout()
            case .designerCollectionImagesPart1, .designerCollectionImagesPart2: return self.createDesignerCollectionImagesSectionLayout()
            case .products: return self.createProductsSectionLayout()
            }
        }, configuration: config)
        return layout
    }
    
    func generateDisegnerInfoSectionLayout() -> NSCollectionLayoutSection? {
        let inset: CGFloat = 24
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset)
        return section
    }
    
    func generateQuoteSectionLayout() -> NSCollectionLayoutSection {
        let inset: CGFloat = 24
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset)
        return section
    }
    
    func createDesignerCollectionImagesSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        return section
    }
    
    func createProductsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalWidth(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        //section.interGroupSpacing = 8
        return section
    }
}
