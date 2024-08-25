//
//  ProductView.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.07.2024.
//

import UIKit

final class ProductView: UIView {
    
    // MARK: - Constants for constraints
    
    private let tableViewBottomInset: CGFloat = -10
    private let actionButtonViewBottomInset: CGFloat = -20
    private let actionButtonViewSideInset: CGFloat = 16
    private let actionButtonViewHeight: CGFloat = 50
    
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
        print("ProductView deinit")
    }
    
    //MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.isHidden = true
        tableView.register(ProductGaleryCell.self)
        tableView.register(ProductInfoCell.self)
        return tableView
    }()
    
    private lazy var actionButtonView: ProductActionsView = {
        let view = ProductActionsView()
        view.backgroundColor = .clear
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityIndicator.center = self.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // MARK: - Public methods
    
    func setupTableViewDataSource(with dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    func setupTableViewDelegate(with delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
    
    func setupLikeButtonDelegate(_ delegate: ILikeButton) {
        actionButtonView.setupLikeButtonDelegate(delegate)
    }
    
    func updateView(isFavouriteStatus: Bool, productId: Int) {
        tableView.isHidden = false
        actionButtonView.isHidden = false
        updateActivityView(isFavouriteStatus: isFavouriteStatus, productId: productId)
        loadingIndicator.stopAnimating()
        tableView.reloadData()
    }
    
    func updateView(with error: String) {
        
    }
    
    func updateActivityView(isFavouriteStatus: Bool, productId: Int) {
        actionButtonView.updateLikeButton(with: isFavouriteStatus, productId: productId)
    }
    
    func updateBasketButtonTitle(with name: String) {
        actionButtonView.setupBasketButtonTitle(with: name)
    }
}

// MARK: - Setups

private extension ProductView {
    func setupView() {
        backgroundColor = Colours.Main.hayBackground
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(loadingIndicator)
        addSubview(tableView)
        addSubview(actionButtonView)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: actionButtonView.topAnchor, constant: tableViewBottomInset).isActive = true
        
        actionButtonView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: actionButtonViewBottomInset).isActive = true
        actionButtonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: actionButtonViewSideInset).isActive = true
        actionButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -actionButtonViewSideInset).isActive = true
        actionButtonView.heightAnchor.constraint(equalToConstant: actionButtonViewHeight).isActive = true
    }
}
