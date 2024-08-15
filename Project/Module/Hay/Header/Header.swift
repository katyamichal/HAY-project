//
//  Header.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.

import UIKit

protocol IHeaderView: AnyObject {
    func update(with inspiration: [InspirationFeed])
}

final class Header: UIView {
    
    var viewModel: HeaderViewModel?
    private var pages: [InspirationSingleView] = []
    
    // MARK: - Constatns

    private let pageControlTopConstant: CGFloat = 70
    private let pageControlLeadingConstant: CGFloat = -15
    private let pageControlHeightConstant: CGFloat = 20
    
    private let detailButtonBottomConstant: CGFloat = -16
    private let detailButtonTrailingConstant: CGFloat = -20
    private let detailButtonHeightConstant: CGFloat = 40
    private let detailButtonWidthConstant: CGFloat = 60
    
    private let detailButtonPaddingTopAndLeft: CGFloat = 40
    private let detailButtonPaddingBottom: CGFloat = 16
    private let detailButtonPaddingRight: CGFloat = 20
    
    // MARK: - Changable Constraints
    
    private var scrollViewHeight = NSLayoutConstraint()
    private var scrollViewBottom = NSLayoutConstraint()
    private var containerHeight = NSLayoutConstraint()
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeader()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Header deinit")
    }
    
    // MARK: - UI Elements
    
    private var container = UIView()
    private let scrollView = UIScrollView()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .white
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        return pageControl
    }()
    
    private lazy var detailButton: CustomButton = {
        let button = CustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colours.HayHeader.detailButtonColour
        button.setImage(UIImage(systemName: Constants.SystemUIElementNames.detailArrow), for: .normal)
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        button.clipsToBounds = true
        ///  setting padding area of the view' size blocks scroll view touches
        button.touchAreaPadding = UIEdgeInsets(top: detailButtonPaddingTopAndLeft, left: detailButtonPaddingTopAndLeft, bottom: detailButtonPaddingBottom, right: detailButtonPaddingRight)
        button.isHidden = true
        return button
    }()
    
    // MARK: - Public
    
    func setupDetailAction(_ target: Any, action: Selector, for event: UIControl.Event = .touchUpInside) {
        detailButton.addTarget(self, action: action, for: event)
    }
    
    func setupViewModel() {
        viewModel?.setupView(with: self)
    }
}

// MARK: - Header Protocol

extension Header: IHeaderView {
    func update(with inspiration: [InspirationFeed]) {
        pageControl.numberOfPages = inspiration.count
        setupScrollViewPages(with: inspiration)
        detailButton.isHidden = false
    }
}

// MARK: - Setup methods

private extension Header {
    func setupHeader() {
        setupViews()
        setupConstrains()
    }
    
    func setupViews() {
        addSubview(container)
        addSubview(detailButton)
        container.addSubview(scrollView)
        container.addSubview(pageControl)
    }
    
    func setupConstrains() {
        pageControl.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: pageControlTopConstant).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: pageControlLeadingConstant).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: pageControlHeightConstant).isActive = true
        
        widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        detailButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: detailButtonBottomConstant).isActive = true
        detailButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: detailButtonTrailingConstant).isActive = true
        detailButton.heightAnchor.constraint(equalToConstant: detailButtonHeightConstant).isActive = true
        detailButton.widthAnchor.constraint(equalToConstant: detailButtonWidthConstant).isActive = true
        
        // MARK:  Changable constraints
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        containerHeight = container.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerHeight.isActive = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewBottom = scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        scrollViewBottom.isActive = true
        scrollViewHeight = scrollView.heightAnchor.constraint(equalTo: container.heightAnchor)
        scrollViewHeight.isActive = true
        scrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
    }
    
    func setupScrollViewPages(with inspiration: [InspirationFeed]) {
        guard !inspiration.isEmpty, pages.isEmpty else { return }
        scrollView.frame = CGRect(x: .zero, y: .zero, width: Constants.Layout.width, height: Constants.Layout.headerHeight)
        scrollView.contentSize = CGSize(width: Constants.Layout.width * CGFloat(Float(inspiration.count)), height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        pageControl.numberOfPages = inspiration.count
        
        pages = inspiration.enumerated().map { index, inspirationItem -> InspirationSingleView in
            let page = InspirationSingleView(frame: CGRect(
                x: CGFloat(index) * Constants.Layout.width,
                y: 0,
                width: Constants.Layout.width,
                height: scrollView.frame.size.height))
            page.update(collectionName: inspirationItem.collectionName.uppercased(), image: UIImage(named: inspirationItem.coverImage) ?? UIImage())
            scrollView.addSubview(page)
            return page
        }
    }
    
    @objc
    func pageControlDidChange(_ sender: UIPageControl) {
        let current = CGFloat(sender.currentPage)
        scrollView.setContentOffset(CGPoint(x: current * (Constants.Layout.width), y: 0), animated: true)
    }
}

// MARK: - Magic goes here

extension Header: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !pages.isEmpty else { return }
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        if offsetY <= 0 && scrollView.contentOffset.x > 0 {
            pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(max(1, scrollView.frame.size.width))))
        }
        containerHeight.constant = scrollView.contentInset.top
        container.clipsToBounds = offsetY <= 0
        scrollViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
        pages[pageControl.currentPage].imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
