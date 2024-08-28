//
//  DesignerTableCell.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.

import UIKit

protocol IDesignerView: AnyObject {
    
}

final class DesignerTableCell: UITableViewCell {
    
    var viewModel: IDesignerViewModel?
    
    // MARK: - Constants for constraints
    
    private let containerViewTopMargin: CGFloat = 20
    private let containerViewHeight: CGFloat = 600
    private let headerLabelLeadingMargin: CGFloat = 8
    private let designerStackViewTopMargin: CGFloat = 20
    private let collectionViewTopMargin: CGFloat = -25
    private let collectionViewBottomMargin: CGFloat = -8
    private let collectionViewLeadingMargin: CGFloat = 30
    
    private let imageViewhHeight: CGFloat = Constants.Layout.width * 0.7
    private let imageViewWidth: CGFloat = Constants.Layout.width * 0.65
    
    static var reuseIdentifier: String {
        return String(describing: DesignerTableCell.self)
    }
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DesignerTableCell deinit")
    }
    
    // MARK: - UI Elements
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.Titles.title
        label.textColor = .black
        return label
    }()
    
    // MARK: - Designer Description
    
    private lazy var designerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = Fonts.Subtitles.defaultFont
        label.textColor = .black
        return label
    }()
    
    private lazy var collectionNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.Subtitles.defaultFont
        label.textColor = .black
        return label
    }()
    
    lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .leading
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 3, bottom: 0, trailing: 3)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // MARK: - Designer StackView
    
    private lazy var designerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageViewhHeight).isActive = true
        return imageView
    }()
    
    lazy var designerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // MARK: - Collection View
    
    lazy var collectionView: UICollectionView = {
        let itemWidth: CGFloat = Constants.Layout.width * 0.5
        let itemHeight: CGFloat = Constants.Layout.width * 0.7
        let itemSpacing: CGFloat = 16
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(DesignerProductsCollectionCell.self, forCellWithReuseIdentifier: DesignerProductsCollectionCell.reuseIdentifier)
        return collection
    }()
    
    // MARK: - Public
    
    func update(sectionName: String, name: String, collectionName: String, image: UIImage, products: [Product]) {
        designerNameLabel.text = name
        collectionNameLabel.text = collectionName
        designerImageView.image = image
        headerLabel.text = sectionName
        updateCollectionView()
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
}

// MARK: - Setup methods

private extension DesignerTableCell {
    func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(headerLabel)
        containerView.addSubview(designerStackView)
        designerStackView.addArrangedSubview(designerImageView)
        designerStackView.addArrangedSubview(descriptionStackView)
        descriptionStackView.addArrangedSubview(designerNameLabel)
        descriptionStackView.addArrangedSubview(collectionNameLabel)
        containerView.addSubview(collectionView)
    }
    
    
    func setupConstraints() {
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: containerViewTopMargin).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: containerViewHeight).isActive = true
        
        headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: headerLabelLeadingMargin).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        designerStackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: designerStackViewTopMargin).isActive = true
        designerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        designerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: designerStackView.bottomAnchor, constant: collectionViewTopMargin).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: collectionViewBottomMargin).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: designerStackView.leadingAnchor, constant: collectionViewLeadingMargin).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
}

// MARK: - Collection Data Source

extension DesignerTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.productCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesignerProductsCollectionCell.reuseIdentifier, for: indexPath) as? DesignerProductsCollectionCell else {
           return UICollectionViewCell()
        }
        viewModel.setCurrentProduct(at: indexPath.item)
        cell.update(productName: viewModel.productName, price: viewModel.productPrice, image: viewModel.productImage, isFavourite: viewModel.isFavourite, productId: viewModel.productId)
        return cell
    }
}

// MARK: - Collection Delegate

extension DesignerTableCell: UICollectionViewDelegate {}
