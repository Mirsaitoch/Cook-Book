//
//  Font+Custom.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import SwiftUI

extension Font {
    enum InterFont {
        case interMedium
        case interBold
        case interBlack
        
        var value: String {
            switch self {
            case .interMedium:
                return "Inter18pt-Medium"
            case .interBold:
                return "Inter28pt-SemiBold"
            case .interBlack:
                return "Inter28pt-Black"
            }
        }
    }
    
    static func inter(_ name: InterFont, size: CGFloat = 20.0) -> Font {
        return Font.custom(name.value, size: size)
    }
}
