//
//  QuoteSupplementaryView.swift
//  Project
//
//  Created by Catarina Polakowsky on 28.08.2024.
//

import UIKit

final class QuoteSupplementaryView: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: DesignerCollectionImages.self)
    }   
    private let quoteLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            addSubview(quoteLabel)
        backgroundColor = .yellow
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quoteLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            quoteLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            quoteLabel.topAnchor.constraint(equalTo: topAnchor),
            quoteLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with quote: String) {
        quoteLabel.text = quote
    }
}
