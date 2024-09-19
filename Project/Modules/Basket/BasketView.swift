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
        label.font = .systemFont(ofSize: 22, weight: .light)
        label.textColor = .label
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
        headerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
}

