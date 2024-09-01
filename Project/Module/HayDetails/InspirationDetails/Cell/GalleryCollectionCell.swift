//
//  GalleryCollectionCell.swift
//  Project
//
//  Created by Catarina Polakowsky on 23.08.2024.
//

import UIKit

final class GalleryCollectionCell: UICollectionViewCell {
    
    static var cellIdentifier: String {
        String(describing: GalleryCollectionCell.self)
    }
    
    // MARK: - Constants for constraints
    
    private let scrollViewHeight = Constants.Layout.height / 1.8
    private let verticalStackSpacing: CGFloat = 30
    private let verticalStackInset: CGFloat = 30
    private let verticalStackBottomPadding: CGFloat = 40
    
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
        print("GalleryCollectionCell deinit")
    }
    
    // MARK: -  UIElements
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .white
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        return pageControl
    }()
    
    private lazy var verticalStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = verticalStackSpacing
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: verticalStackInset, left: verticalStackInset, bottom: verticalStackBottomPadding, right: verticalStackInset)
        return stackView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Titles.title
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: Label = {
        let label = Label(style: .description)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    // MARK: - Public
    
    func update(with collectionName: String, descriptionText: String, images: [UIImage]) {
        productNameLabel.text = collectionName
        descriptionLabel.text = descriptionText
        configureGalleryView(with: images)
        pageControl.isHidden = images.count == 1
    }
}

// MARK: - View setup methods

private extension GalleryCollectionCell {
    func setupCell() {
        backgroundColor = .clear
        setupViews()
        setupConstraints()
        setupScrollView()
    }
    
    func setupViews() {
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(productNameLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        contentView.addSubview(scrollView)
        contentView.addSubview(pageControl)
    }
    
    func setupConstraints() {
        scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true
        
        pageControl.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        verticalStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

// MARK: - Scroll view gallery setups

private extension GalleryCollectionCell {
    func setupScrollView() {
        scrollView.frame = CGRect(x: .zero, y: .zero, width: Constants.Layout.width, height: scrollViewHeight)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureGalleryView(with images: [UIImage]) {
        pageControl.numberOfPages = images.count
        scrollView.contentSize = CGSize(width: Constants.Layout.width * CGFloat(images.count), height: scrollViewHeight)
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        for index in 0..<images.count {
            let page = UIImageView(frame: CGRect(
                x: CGFloat(index) * Constants.Layout.width,
                y: 0,
                width: Constants.Layout.width,
                height: scrollView.frame.size.height))
            page.contentMode = .scaleToFill
            page.clipsToBounds = true
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

// MARK: - Scroll view Delegate

extension GalleryCollectionCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
}



