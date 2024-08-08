//
//  BuyButton.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//


import UIKit

class BuyButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Buy deinit")
    }
    
    // MARK: - setup methods
    
    private func setupButton() {
        self.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let largeFont = UIFont.systemFont(ofSize: 16)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let buttonImage = UIImage(systemName: "bag", withConfiguration: configuration)
        self.setImage(buttonImage, for: .normal)
        self.backgroundColor = Colours.Text.selectedColour
        self.layer.cornerRadius = 18
        self.tintColor = .white
    }
}
