//
//  DesignerTableCell.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.

import UIKit

final class DesignerTableCell: UITableViewCell {
    
    private var designerProduct: [Product] = []
    
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
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "HAY × Designers"
        label.textColor = .black
        return label
    }()
    
    
    // MARK: - Designer Description
    
    private lazy var designerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 21, weight: .light)
        label.textColor = .black
        return label
    }()
    
    private lazy var collectionNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .light)
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
        imageView.widthAnchor.constraint(equalToConstant: Constants.Layout.width * 0.65).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.Layout.width * 0.7).isActive = true
        return imageView
    }()
    
    lazy var designerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .leading
       // stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    // MARK: - Collection View
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Constants.Layout.width * 0.5, height: Constants.Layout.width * 0.7)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
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
    
    func update(name: String, collectionName: String, image: UIImage, products: [Product]) {
        designerNameLabel.text = name
        collectionNameLabel.text = collectionName
        designerImageView.image = image
        designerProduct = products
        collectionView.reloadData()
    }
}

// MARK: - Setups

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
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 600).isActive = true
        
        headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        designerStackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        designerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        designerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: designerStackView.bottomAnchor, constant: -25).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: designerStackView.leadingAnchor, constant: 30).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
}

// MARK: - Collection Data Source

extension DesignerTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return designerProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesignerProductsCollectionCell.reuseIdentifier, for: indexPath) as? DesignerProductsCollectionCell else {
           return UICollectionViewCell()
        }
        let product = designerProduct[indexPath.item]
        cell.update(productName: product.productName, price: "£\(product.price)", image: UIImage(named: product.image)!)
        return cell
    }
}

// MARK: - Collection Delegate

extension DesignerTableCell: UICollectionViewDelegate {}
