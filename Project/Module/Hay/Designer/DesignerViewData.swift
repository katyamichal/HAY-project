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
    let products: [ProductCDO]
}

extension DesignerViewData {
    init(with designer: Designer) {
        self.designerId = designer.id
        self.designerName = designer.designerName
        self.collectionName = designer.collectionName
        self.products = designer.products.map({ProductCDO(with: $0, endpoint: .designers, itemIdentifier: designer.id, type: .favourite)})
    }
}
