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
    
    // MARK: - Constants for constraints
    private let likeButtonTopMargin: CGFloat = 16
    private let likeButtonTrailingMargin: CGFloat = -1
    private let likeButtonWidth: CGFloat = 25
    private let likeButtonHeight: CGFloat = 25

    private let productImageViewHeightMultiplier: CGFloat = 0.7
    private let productImageViewTopMargin: CGFloat = -8

    private let verticalStackViewTopMargin: CGFloat = 8
    private let verticalStackViewLeadingMargin: CGFloat = 3
    
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
        label.font = Fonts.Subtitles.defaultFont
        label.textColor = .black
        return label
    }()
    
    private lazy var pricelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 0
        label.font = Fonts.Subtitles.defaultFont
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
    
    private lazy var likeButton: LikeButton = {
        let button = LikeButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public
    
    func update(productName: String, price: String, image: UIImage, isFavourite: Bool, productId: Int) {
        nameLabel.text = productName
        pricelLabel.text = price
        productImageView.image = image
        setupLikeButton(with: isFavourite, productId: productId)
    }
    
    func setupLikeButton(with status: Bool, productId: Int) {
        likeButton.isSelected = status
        likeButton.productId = productId
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
        likeButton.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: likeButtonTopMargin).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: likeButtonTrailingMargin).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: likeButtonWidth).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: likeButtonHeight).isActive = true
        
        productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: productImageViewHeightMultiplier).isActive = true
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: productImageViewTopMargin).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        verticalStackView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: verticalStackViewTopMargin).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: verticalStackViewLeadingMargin).isActive = true
    }
}
