//
//  TextCollectionCell.swift
//  Project
//
//  Created by Catarina Polakowsky on 27.08.2024.
//

import UIKit

final class TextCollectionCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        String(describing: TextCollectionCell.self)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("TextCollectionCell deinit")
    }
    
    // MARK: - UI Element
    
    private lazy var designerTextLabel: Label = {
        let label = Label(style: .description)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: - Public
    
    func update(quote: String) {
        designerTextLabel.text = quote
    }
}

private extension TextCollectionCell {
    func setupCell() {
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        contentView.addSubview(designerTextLabel)
    }
    
    func setupConstraints() {
        designerTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        designerTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        designerTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        designerTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}
