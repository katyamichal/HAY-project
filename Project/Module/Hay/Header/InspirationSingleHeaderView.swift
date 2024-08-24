//
//  InspirationSingleView.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.

import UIKit



final class InspirationSingleView: UIView {
    
    // MARK: - Constants for constraints
    
    private let imageViewWidth: CGFloat = UIScreen.main.bounds.width
    private let topBlurryViewHeight: CGFloat = 135
    private let collectionNameLabelTopMargin: CGFloat = 90
    private let collectionNameLabelLeadingMargin: CGFloat = 20
    private let collectionNameLabelHeight: CGFloat = 40
    
    // MARK: - Changeble constrain
    
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
    
    deinit {
        print("InspirationSingleView deinit")
    }
    
    // MARK: - UI Elements
    
    private lazy var collectionNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.Subtitles.defaultFont
        label.textColor = .black
        return label
    }()
    
    private lazy var topBlurryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colours.Main.hayBackgroundAlpha
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Public
    
    func update(collectionName: String, image: UIImage) {
        collectionNameLabel.text = collectionName
        imageView.image = image
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
        imageView.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        topBlurryView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        topBlurryView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        topBlurryView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        topBlurryView.heightAnchor.constraint(equalToConstant: topBlurryViewHeight).isActive = true
        
        collectionNameLabel.topAnchor.constraint(equalTo: topBlurryView.topAnchor, constant: collectionNameLabelTopMargin).isActive = true
        collectionNameLabel.leadingAnchor.constraint(equalTo: topBlurryView.leadingAnchor, constant: collectionNameLabelLeadingMargin).isActive = true
        collectionNameLabel.heightAnchor.constraint(equalToConstant: collectionNameLabelHeight).isActive = true
        
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        imageViewHeight.isActive = true
    }
}
