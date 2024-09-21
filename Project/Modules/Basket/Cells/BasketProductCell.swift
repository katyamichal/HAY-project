//
//  BasketProductCell.swift
//  Project
//
//  Created by Catarina Polakowsky on 19.09.2024.
//

import UIKit

final class BasketProductTableCell: UITableViewCell {
    
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
        print("BasketProductTableCell deinit")
    }
    
    
    // MARK: - UI Elements
    
    private lazy var nameLabel: Label = {
        let label = Label(style: .description)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 12)
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
    
    private lazy var detailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let largeFont = UIFont.systemFont(ofSize: 20)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let buttonImage = UIImage(systemName: "ellipsis", withConfiguration: configuration)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .tertiaryLabel
        return imageView
    }()
    
    // MARK: - Public
    
    func update(productName: String, price: String, image: UIImage, count: String? = nil) {
        nameLabel.text = productName
        pricelLabel.text = price
        productImageView.image = image
        countLabel.text = count
    }
    
    // MARK: - Prepare for Reuse

    override func prepareForReuse() {
        nameLabel.text = nil
        pricelLabel.text = nil
        productImageView.image = nil
        countLabel.text = nil
        super.prepareForReuse()
    }
}

private extension BasketProductTableCell {
    
    func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(productImageView)
        productImageView.addSubview(countLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailButton)
        contentView.addSubview(pricelLabel)
    }
    
    func setupConstraints() {
        
        productImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        productImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        
        countLabel.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor).isActive = true
        countLabel.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -3).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 20).isActive = true
        
        detailButton.topAnchor.constraint(equalTo: productImageView.topAnchor).isActive = true
        detailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        pricelLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        pricelLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    }
}

