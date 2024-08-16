//
//  DesignerDetailsViewData.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import Foundation

struct DesignerDetailsViewData {
    let designerId: Int
    let designerName: String
    let collectionName: String
    let designerInfo: String
    let description: String
    let designerQuotes: [String]
    let designerImage: String
    let collectionImages: [String]
    let products: [ProductCDO]
}

extension DesignerDetailsViewData {
    init(with designer: Designer) {
        self.designerId = designer.id
        self.designerName = designer.designerName
        self.collectionName = designer.collectionName
        self.designerInfo = designer.designerInfo
        self.description = designer.description
        self.designerQuotes = designer.designerQuotes
        self.designerImage = designer.designerImage
        self.collectionImages = designer.collectionImages
        self.products = designer.products.map({ProductCDO(with: $0, type: .favourite)})
    }
}
