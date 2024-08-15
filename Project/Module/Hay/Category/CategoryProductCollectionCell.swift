//
//  Coordinator.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import UIKit

final class CategoryProductCollectionCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: CategoryProductCollectionCell.self)
    }
    
    private let likeButtonTopInset: CGFloat = 16
    private let likeButtonTrailingInset: CGFloat = -1
    private let likeButtonSize: CGFloat = 25
    private let productImageViewWidth: CGFloat = Constants.Layout.width * 0.6
    private let productImageViewHeight: CGFloat = Constants.Layout.width * 0.6
    
    
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
        print("CategoryProductCollectionCell deinit")
    }
    
    // MARK: - UI Elements
    
    private lazy var verticalStackView: UIStackView = {
        var stackView = UIStackView.init()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 3, trailing: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.Subtitles.defaultFont
        label.textColor = .black
        return label
    }()
    
    private lazy var pricelLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.Subtitles.defaultFont
        label.textColor = .black
        return label
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    func setupLikeButtonDelegate(_ delegate: ILikeButton) {
        likeButton.delegate = delegate
    }
    
    func setupLikeButton(with status: Bool, productId: Int) {
        likeButton.isSelected = status
        likeButton.productId = productId
    }
}

private extension CategoryProductCollectionCell {
    func setupCell() {
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
        likeButton.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: likeButtonTopInset).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: likeButtonTrailingInset).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: likeButtonSize).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: likeButtonSize).isActive = true
        
        productImageView.heightAnchor.constraint(equalToConstant: productImageViewHeight).isActive = true
        productImageView.widthAnchor.constraint(equalToConstant: productImageViewWidth).isActive = true
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        
        verticalStackView.topAnchor.constraint(equalTo: productImageView.bottomAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }
}
