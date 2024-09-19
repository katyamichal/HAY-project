//
//  LabelFactory.swift
//  Project
//
//  Created by Catarina Polakowsky on 01.09.2024.
//

import UIKit

enum LabelStyle: Int {
    case productName
    case description
}

class Label: UILabel {
    
    // MARK: - Inits
    
    init(style: LabelStyle, text: String? = nil) {
        super.init(frame: .zero)
        
        switch style {
        case .productName: createTitleLabel(text: text)
        case .description: createDescriptionLabel(text: text)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods to create labels
    
    func createTitleLabel(text: String?) {
        self.numberOfLines = 0
        self.font = Fonts.Subtitles.defaultFont
        self.textColor = .black
        self.text = text
    }
    
    func createDescriptionLabel(text: String?) {
        self.numberOfLines = 0
        self.font = Fonts.Subtitles.defaultFont
        self.textColor = .black
        self.text = text
    }
}
