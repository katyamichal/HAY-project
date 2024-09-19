//
//  HayTableView.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import UIKit

final class HayTableView: UITableView {
    
    // MARK: - Inits
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("MainTableView deinit")
    }
    
    // MARK: - UI Elements
    
    lazy var tableHeader = Header()
    
    // MARK: - Public
    
    func setupTableDataSource(with delegate: UITableViewDataSource) {
        self.dataSource = delegate
    }
    
    func setupTableViewDelegate(with delegate: UITableViewDelegate) {
        self.delegate = delegate
    }
    
    func scrollHeader() {
        guard let header = self.tableHeaderView as? Header else { return }
        header.scrollViewDidScroll(self)
    }
}

private extension HayTableView {
    func setupHeader() {
        tableHeader.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: Constants.Layout.headerHeight)
        self.tableHeaderView = tableHeader
        self.tableHeaderView?.isUserInteractionEnabled = true
    }
    
    // MARK: - Setup TableView
    
    func setupTableView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
        separatorStyle = .none
        register(CategoryTableCell.self)
        register(DesignerTableCell.self)
        setupHeader()
    }
}
