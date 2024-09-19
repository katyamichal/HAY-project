//
//  OrderTableCell.swift
//  Project
//
//  Created by Catarina Polakowsky on 19.09.2024.
//

import Foundation

import UIKit

final class OrderInfoTableCell: UITableViewCell {
    
    var onOrderButtonTapped: (()->())?
    
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("OrderInfoTableCell deinit")
    }
    
    
    // MARK: - UI Elements
    
    private let separatorLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    
    private let subtotalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.textColor = .black
        return label
    }()
    
    
    private let deliveryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.textColor = .black
        return label
    }()
    
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Total"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    
    private let pricelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    
    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Place your order", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .light)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func orderButtonTapped() {
        onOrderButtonTapped?()
    }
    
    
    // MARK: - Public
    
    func update(orderInfo: [Int]) {
        subtotalLabel.text = "Subtotal  £\(orderInfo[0])"
        deliveryLabel.text = "Delivery £\(orderInfo[1])"
        pricelLabel.text = "£\(orderInfo[2])"
    }
}

// MARK: - Constraints

private extension OrderInfoTableCell {
    
    func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(separatorLineView)
        contentView.addSubview(verticalStackView)
        contentView.addSubview(totalStackView)
        contentView.addSubview(orderButton)
        verticalStackView.addArrangedSubview(subtotalLabel)
        verticalStackView.addArrangedSubview(deliveryLabel)
        totalStackView.addArrangedSubview(totalLabel)
        totalStackView.addArrangedSubview(pricelLabel)
    }
    
    func setupConstraints() {
        separatorLineView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        separatorLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        separatorLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.2).isActive = true
        
        verticalStackView.topAnchor.constraint(equalTo: separatorLineView.topAnchor, constant: 20).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        verticalStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        verticalStackView.widthAnchor.constraint(equalToConstant: Constants.Layout.width / 2.1).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: totalStackView.topAnchor).isActive = true
        
        totalStackView.leadingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: 10).isActive = true
        totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        totalStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        totalStackView.bottomAnchor.constraint(equalTo: orderButton.topAnchor, constant: -40).isActive = true
        
        orderButton.widthAnchor.constraint(equalToConstant: Constants.Layout.width / 1.1).isActive = true
        orderButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        orderButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        orderButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40).isActive = true
        
    }
}
