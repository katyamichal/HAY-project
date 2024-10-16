//
//  BasicCollectionViewCell.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import UIKit

final class BasicCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        String(describing: BasicCollectionViewCell.self)
    }
    
    // MARK: - Constants for constraints
    
    private let buttonInset: CGFloat = 6
    private let likeButtonSize: CGFloat = 25
    private let productImageViewHeightMultiplier: CGFloat = 0.7
    private let buyButtonSize: CGFloat = 35
    private let buyButtonTopInset: CGFloat = -15
    private let verticalStackViewInset: CGFloat = 8
    private let verticalStackViewTrailingInset: CGFloat = -20
    
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
        print("BasicCollectionViewCell deinit")
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
    
    private lazy var nameLabel: Label = {
        let label = Label(style: .productName)
        return label
    }()
    
    private lazy var pricelLabel: Label = {
        let label = Label(style: .description)
        return label
    }()
    
    private lazy var buyButton: BuyButton = {
        let button = BuyButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    func update(productName: String, price: String, image: UIImage,  isFavourite: Bool, productId: Int) {
        nameLabel.text = productName
        pricelLabel.text = price
        productImageView.image = image
        setupLikeButton(with: isFavourite, productId: productId)
    }
    
    func setupLikeButtonDelegate(_ delegate: ILikeButton) {
        likeButton.delegate = delegate
    }
    
    func setupLikeButton(with status: Bool, productId: Int) {
        likeButton.isSelected = status
        likeButton.productId = productId
    }
   
    // MARK: - Prepare for Reuse

    override func prepareForReuse() {
        nameLabel.text = nil
        pricelLabel.text = nil
        productImageView.image = nil
        likeButton.delegate = nil
        likeButton.isSelected = false
        likeButton.productId = nil
        super.prepareForReuse()
    }
}
// MARK: - Setup methods

private extension BasicCollectionViewCell {
    func setupCell() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(productImageView)
        contentView.addSubview(verticalStackView)
        contentView.addSubview(buyButton)
        contentView.addSubview(likeButton)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(pricelLabel)
    }
    
    func setupConstraints() {
         likeButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: buttonInset).isActive = true
         likeButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -buttonInset).isActive = true
         likeButton.widthAnchor.constraint(equalToConstant: likeButtonSize).isActive = true
         likeButton.heightAnchor.constraint(equalToConstant: likeButtonSize).isActive = true
         
         productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: productImageViewHeightMultiplier).isActive = true
         productImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
         productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
         productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
         
         buyButton.widthAnchor.constraint(equalToConstant: buyButtonSize).isActive = true
         buyButton.heightAnchor.constraint(equalToConstant: buyButtonSize).isActive = true
         buyButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -buttonInset).isActive = true
         buyButton.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: buyButtonTopInset).isActive = true
         
         verticalStackView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: verticalStackViewInset).isActive = true
         verticalStackView.trailingAnchor.constraint(equalTo: buyButton.leadingAnchor, constant: verticalStackViewTrailingInset).isActive = true
         verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: verticalStackViewInset).isActive = true
     }
}
