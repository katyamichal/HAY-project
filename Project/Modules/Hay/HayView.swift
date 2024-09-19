//
//  HayView.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.

import UIKit


final class HayView: UIView {
    
    // MARK: - Constants for constraints
    private let inset: CGFloat = 16
    
    var showErrorMessage: String? {
        didSet {
            tableView.isHidden = true
            errorLabel.isHidden = false
            errorLabel.text = showErrorMessage
        }
    }
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
        print("MainView deinit")
    }
    
    // MARK: - UI Elements
    
    private(set) var tableView = HayTableView()
    
    private lazy var errorLabel: Label = {
        let label = Label(style: .description)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    // MARK: - Public methods
    
    func setupDataSource(with delegate: UITableViewDataSource) {
        tableView.setupTableDataSource(with: delegate)
    }
    
    func setupTableViewDelegate(with delegate: UITableViewDelegate) {
        tableView.setupTableViewDelegate(with: delegate)
    }
}

// MARK: - Setup methods

private extension HayView {
    func setupView() {
        backgroundColor = Colours.Main.hayBackground
        tableView.backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(errorLabel)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        errorLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: inset).isActive = true
        errorLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: inset).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -inset).isActive = true
        
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
