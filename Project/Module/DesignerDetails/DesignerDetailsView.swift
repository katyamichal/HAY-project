//
//  DesignerDetailsView.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import UIKit

final class DesignerDetailsView: UIView {

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DesignerDetailsView deinit")
    }
}
