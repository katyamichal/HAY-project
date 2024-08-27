//
//  DesignerInfoCollectionCell.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.08.2024.
//

import UIKit

final class DesignerInfoCollectionCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: DesignerInfoCollectionCell.self)
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
    
    // MARK: - UI Element
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 16

        return stackView
    }()
    
    private lazy var collaborationName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = Fonts.Subtitles.secondaryFont
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var disignerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var designerBioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = Fonts.Subtitles.defaultFont
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Public
    
    func update(name: String, designerImage: UIImage, designerBio: String) {
        collaborationName.text = name
        disignerImageView.image = designerImage
        designerBioLabel.text = designerBio
    }
}

private extension DesignerInfoCollectionCell {
    func setupCell() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(collaborationName)
        stackView.addArrangedSubview(disignerImageView)
        stackView.addArrangedSubview(designerBioLabel)
    }
    
    func setupConstraints() {
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
