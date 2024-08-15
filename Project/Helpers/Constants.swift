//
//  Constants.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import UIKit

enum Constants {
    enum Layout {
        static let width = UIScreen.main.bounds.width
        static let bounds = UIScreen.main.bounds
        static let height = UIScreen.main.bounds.height
        static let headerHeight = UIScreen.main.bounds.height / 1.5
    }
    
    enum LoadingMessage {
        static let noInternetConnection = "Poor Internet Connection. Please check your network settings and try again."
        static let failFetchData = "We're sorry but something hasn't worked. Please check the URL and try testing again."
        static let serverError = "Our server is currently unavailable. Please try again later."
        static let urlSessionError = "Oops! Something went wrong while getting your result. Please try again."
        static let unknown = "We are trying to figure it out why the app is not working"
    }
    
    enum SystemUIElementNames {
        static let detailArrow = "arrow.right"
    }
    
    enum LabelTitle {
        static let designerSection = "HAY × Designers"
    }
}
