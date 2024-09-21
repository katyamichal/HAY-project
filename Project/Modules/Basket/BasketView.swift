//
//  BasketView.swift
//  Project
//
//  Created by Catarina Polakowsky on 19.09.2024.
//

import UIKit

enum BasketTableSection: CaseIterable {
    case products
    case orderInfo
}

final class BasketView: UIView {
    
    // MARK: - Constants for constraints
    
    private let headerTopPadding: CGFloat = 40.0
    private let headerSidePadding: CGFloat = 20.0
    private let headerBottomPadding: CGFloat = 10.0
    
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
        print("BasketView deinit")
    }
    
    // MARK: - UI Elements
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        tableView.register(BasketProductTableCell.self)
        tableView.register(OrderInfoTableCell.self)
        return tableView
    }()
    
    // MARK: - Public methods
    
    func setupTableViewDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
    
    func setupTableViewDataSource(_ dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    func updateTableView() {
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func updateHeader(with title: String, and font: UIFont) {
        headerLabel.text = title
        headerLabel.font = font
    }
}
// MARK: - Setup methods

private extension BasketView {
    func setupCell() {
        backgroundColor = Colours.Main.hayBackground
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(headerLabel)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        headerLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: headerTopPadding).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: headerSidePadding).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -headerSidePadding).isActive = true
        
        tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: headerBottomPadding).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
}

