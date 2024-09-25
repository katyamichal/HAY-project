//
//  BuyButton.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import UIKit

protocol IBuyButton: AnyObject {
    func addProductToBasket(with id: Int)
}
class BuyButton: UIButton {
    weak var delegate: IBuyButton?
    var productId: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("BuyButton deinit")
    }
    
    // MARK: - setup methods
    
    private func setupButton() {
        self.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let largeFont = UIFont.systemFont(ofSize: 16)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let buttonImage = UIImage(systemName: "bag", withConfiguration: configuration)
        self.setImage(buttonImage, for: .normal)
        self.backgroundColor = Colours.Text.selectedColour.withAlphaComponent(0.9)
        self.layer.cornerRadius = 18
        self.tintColor = .white
        self.addTarget(self, action: #selector(didSelectedBuyButton), for: .touchUpInside)
    }
    
    @objc
    func didSelectedBuyButton() {
        guard let productId else { return }
        delegate?.addProductToBasket(with: productId)
    }
}
