//
//  DesignerCollectionImages.swift
//  Project
//
//  Created by Catarina Polakowsky on 27.08.2024.
//

import UIKit

final class DesignerCollectionImages: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: DesignerCollectionImages.self)
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
        print("DesignerInfoCollectionCell deinit")
    }
    
    // MARK: - UI Elemant

    private lazy var collectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Public
    
    func update(with image: UIImage) {
        collectionImageView.image = image
    }
}

private extension DesignerCollectionImages {
    func setupCell() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(collectionImageView)
    }
    
    func setupConstraints() {
        collectionImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        collectionImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
