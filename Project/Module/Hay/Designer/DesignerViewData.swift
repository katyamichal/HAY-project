//
//  DesignerViewData.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import Foundation

struct DesignerViewData {
    let designerId: Int
    let designerName: String
    let collectionName: String
    let product: [ProductCDO]
}

extension DesignerViewData {
    init(with designer: Designer) {
        self.designerId = designer.id
        self.designerName = designer.designerName
        self.collectionName = designer.collectionName
        self.product = designer.products.map({ProductCDO(with: $0, type: .favourite)})
    }
}
