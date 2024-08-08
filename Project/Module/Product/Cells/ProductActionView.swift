//
//  ProductActionView.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.07.2024.
//

import UIKit

final class ProductActionsView: UIView {
    
    private let basketButtonWidth: CGFloat = Constants.Layout.width / 1.3
    private let buttonSpacing: CGFloat = 10
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ProductActionsView Deinit")
    }
    
    // MARK: - UI Elements
    
    private let likeButton: LikeButton = {
        let button = LikeButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Colours.Main.hayBackground
        button.backgroundColor = .black
        return button
    }()
    
    private let basketButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .light)
        button.setTitle("Add to Basket", for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    
    // MARK: - Public
    
    func update(product: Product) {}
    
    func setupLikeButtonAction(_ target: Any, action: Selector, for event: UIControl.Event = .touchDown) {
        likeButton.addTarget(target, action: action, for: event)
    }
}

// MARK: - Setups

private extension ProductActionsView {
    func setupView() {
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(likeButton)
        addSubview(basketButton)
    }
    
    func setupConstraints() {
        basketButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        basketButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        basketButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        basketButton.widthAnchor.constraint(equalToConstant: basketButtonWidth).isActive = true
        
        likeButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: basketButton.trailingAnchor, constant: buttonSpacing).isActive = true
        likeButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
