//
//  DesignerProductsCollectionCell.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.

import UIKit

final class DesignerProductsCollectionCell: UICollectionViewCell {

    static var reuseIdentifier: String {
        return String(describing: DesignerProductsCollectionCell.self)
    }
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DesignerProductsCollectionCell deinit")
    }
    
    // MARK: - UI Elements
    
    private lazy var verticalStackView: UIStackView = {
        var stackView = UIStackView.init()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    private lazy var pricelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var likeButton: LikeButton = {
        let button = LikeButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public
    
    func update(productName: String, price: String, image: UIImage) {
        nameLabel.text = productName
        pricelLabel.text = price
        productImageView.image = image
    }
}

private extension DesignerProductsCollectionCell {
    func setupCell() {
        contentView.backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(productImageView)
        contentView.addSubview(verticalStackView)
        contentView.addSubview(likeButton)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(pricelLabel)
    }
    
    func setupConstraints() {
        likeButton.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -1).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -8).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        verticalStackView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3).isActive = true
    }
}
