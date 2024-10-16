//
//  LikeButton.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import UIKit

protocol ILikeButton: AnyObject {
    func changeStatus(with id: Int)
}

class LikeButton: UIButton {
    weak var delegate: ILikeButton?
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
        print("Like buttn deinit")
    }
    
    // MARK: -  Setup Methods
    
    private func setupButton() {
        self.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        self.tintColor = Colours.Text.selectedColour
        
        let font = UIFont.systemFont(ofSize: 17)
        let configuration = UIImage.SymbolConfiguration(font: font)
        
        let unselectedImage = UIImage(systemName: "heart", withConfiguration: configuration)
        let selectedImage = UIImage(systemName: "heart.fill", withConfiguration: configuration)
    
        self.setImage(unselectedImage, for: .normal)
        self.setImage(selectedImage, for: .selected)
        self.addTarget(self, action: #selector(didSelectedLikeButton), for: .touchUpInside)
    }
    
    @objc
    func didSelectedLikeButton() {
        guard let productId else { return }
        delegate?.changeStatus(with: productId)
    }
}
