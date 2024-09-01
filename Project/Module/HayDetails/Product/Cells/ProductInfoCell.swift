//
//  ProductInfoCell.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.07.2024.
//

import UIKit

final class ProductInfoCell: UITableViewCell {
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var verticalStackView: UIStackView = {
        var stackView = UIStackView.init()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var infoType: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.Subtitles.secondaryFont
        label.textColor = .black
        return label
    }()
    
    private lazy var infoDescription: Label = {
        let label = Label(style: .description)
        return label
    }()
    
    
    // MARK: - Public
    
    func update(infoType: String, infoDesscription: String) {
        self.infoType.text = infoType
        infoDescription.text = infoDesscription
    }
}

// MARK: - Setups

private extension ProductInfoCell {
    func setupCell() {
        contentView.backgroundColor = Colours.Main.hayBackground
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(infoType)
        verticalStackView.addArrangedSubview(infoDescription)
    }
    
    func setupConstraints() {
        verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
