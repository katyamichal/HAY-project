//
//  UIFont + customFont.swift
//  Project
//
//  Created by Catarina Polakowsky on 15.08.2024.
//

import UIKit

enum Fonts {
    enum Titles {
      //  static let title = UIFont.cachedFont(name: "Avenir-Black", size: 24)
        static let title = UIFont.cachedFont(name: "BodoniSvtyTwoITCTT-Bold", size: 21)
    }
    
    enum Subtitles {
        static let largeFont = UIFont.cachedFont(name: "Didot", size: 18)
        static let defaultFont = UIFont.cachedFont(name: "Georgia", size: 18)
        static let secondaryFont = UIFont.cachedFont(name: "Georgia", size: 14)
        static let descriptionFont = UIFont.cachedFont(name: "Didot", size: 14)
    }
    
    enum Buttons {
        static let primaryButtonFont = UIFont.cachedFont(name: "Georgia-Bold", size: 21)
    }
}

extension UIFont {
    
    private static var fontCache: [String: UIFont] = [:]
    public static func cachedFont(name: String, size: CGFloat) -> UIFont {
        let key = "\(name)\(size)"
        if let cachedFont = self.fontCache[key] {
            return cachedFont
        }
        self.clearFontCacheIfNeeded()
        guard let font = UIFont(name: name, size: size) else {
            fatalError("Failed to load font: \(name) with size: \(size)")
        }
        self.fontCache[key] = font
        return font
    }
    
    private static func clearFontCacheIfNeeded() {
        let maxObjectCount = 100
        guard self.fontCache.count >= maxObjectCount else { return }
        self.fontCache = [:]
    }
}
