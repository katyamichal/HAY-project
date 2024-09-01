//
//  ProductGaleryCell.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.07.2024.
//

import Foundation
import UIKit

final class ProductGaleryCell: UITableViewCell {
    
    // MARK: - Constants for constraints
    
    private let scrollViewTopInset: CGFloat = 40
    private let scrollViewSideInset: CGFloat = 16
    private let scrollViewHeight: CGFloat = Constants.Layout.height / 2
    private let pageControlTopInset: CGFloat = 16
    private let pageControlHeight: CGFloat = 10
    private let verticalStackViewSideInset: CGFloat = 16
    private let verticalStackViewBottomInset: CGFloat = -30
    
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
        print("ProductGaleryCell deinit")
    }
    
    // MARK: -  UIElements
    
    private let scrollView = UIScrollView()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .white
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = Colours.Text.selectedColour
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        return pageControl
    }()
    
    private lazy var verticalStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .center
        stackView.backgroundColor = Colours.Main.productDescription
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
        return stackView
    }()
    
    private lazy var productName: UILabel = {
        let label = UILabel()
        label.font = Fonts.Subtitles.largeFont
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: Label = {
        let label = Label(style: .description)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Public

    func update(name: String, description: String, images: [UIImage]) {
        productName.text = name
        descriptionLabel.text = description
        configureViews(with: images, detail: description)
        if images.count == 1 {
            pageControl.isHidden = true
        }
    }
}

// MARK: - Setup methods

private extension ProductGaleryCell {
    func setupCell() {
        backgroundColor = .clear
        setupViews()
        setupConstraints()
        setupScrollView()
    }
    
    func setupViews() {
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(productName)
        verticalStackView.addArrangedSubview(descriptionLabel)
        contentView.addSubview(scrollView)
        contentView.addSubview(pageControl)
    }
    
    func setupConstraints() {
        scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: scrollViewTopInset).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: scrollViewSideInset).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -scrollViewSideInset).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true
        
        pageControl.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: pageControlTopInset).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: pageControlHeight).isActive = true
        
        verticalStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: verticalStackViewSideInset).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -verticalStackViewSideInset).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: verticalStackViewBottomInset).isActive = true
    }
    
    func setupScrollView() {
        scrollView.frame = CGRect(x: .zero, y: .zero, width: Constants.Layout.width, height: scrollViewHeight)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureViews(with images: [UIImage], detail: String) {
        let scrollViewWidth: CGFloat = Constants.Layout.width - 32
        let scrollViewContentMode: UIView.ContentMode = .scaleAspectFill
        let contentWidth = CGFloat(images.count) * scrollViewWidth
        
        pageControl.numberOfPages = images.count
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.size.height)
        
        for index in images.indices {
            let page = UIImageView(frame: CGRect(
                x: CGFloat(index) * scrollViewWidth,
                y: 0,
                width: scrollViewWidth,
                height: scrollView.frame.size.height)
            )
            page.contentMode = scrollViewContentMode
            page.layer.masksToBounds = true
            page.image = images[index]
            scrollView.addSubview(page)
        }
    }
    
    @objc
    func pageControlDidChange(_ sender: UIPageControl) {
        let current = CGFloat(sender.currentPage)
        scrollView.setContentOffset(CGPoint(x: current * (Constants.Layout.width), y: 0), animated: true)
    }
}

extension ProductGaleryCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
}
