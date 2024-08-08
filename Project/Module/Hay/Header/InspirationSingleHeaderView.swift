//
//  InspirationSingleView.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.

import UIKit



final class InspirationSingleView: UIView {
    
    // MARK: - Changable Constraints
    
    private var inspirationFeed: InspirationFeed?
    var imageViewHeight = NSLayoutConstraint()

    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInspirationView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private let collectionNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next Regular", size: 18)
        label.textColor = .black
        return label
    }()
    
    private let topBlurryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colours.Main.hayBackground.withAlphaComponent(0.6)
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Public
    func update(with model: InspirationFeed) {
        self.inspirationFeed = model
        collectionNameLabel.text = model.collectionName.uppercased()
        imageView.image = UIImage(named: "\(model.coverImage)")
    }
}

private extension InspirationSingleView {
    
    func setupInspirationView() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(imageView)
        imageView.addSubview(topBlurryView)
        topBlurryView.addSubview(collectionNameLabel)
    }
    
    func setupConstraints() {
        imageView.widthAnchor.constraint(equalToConstant: self.bounds.size.width).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        topBlurryView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        topBlurryView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        topBlurryView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        topBlurryView.heightAnchor.constraint(equalToConstant: 135).isActive = true
        
        collectionNameLabel.topAnchor.constraint(equalTo: topBlurryView.topAnchor, constant: 90).isActive = true
        collectionNameLabel.leadingAnchor.constraint(equalTo: topBlurryView.leadingAnchor, constant: 20).isActive = true
        collectionNameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        imageViewHeight.isActive = true
    }
}
