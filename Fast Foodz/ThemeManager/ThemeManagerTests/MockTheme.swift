//
//  MockTheme.swift
//  ThemeManagerTests
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

import Foundation
import ThemeManager

extension ThemeColorPalette {
    var color: UIColor {
        switch self {
        case .white: return .white
        case .grey100, .grey300: return .gray
        case .black: return .black
        case .primary: return .blue
        case .error: return .red
        case .success: return .green
        }
    }
}

private extension ThemeFontAttribute {
    func primaryFont(withSize size: CGFloat = UIFont.labelFontSize) -> UIFont {
        switch self {
        case .regular: return .systemFont(ofSize: size)
        case .bold: return .boldSystemFont(ofSize: size)
        }
    }
}

private extension ThemeFontStyle {
    var fontSize: CGFloat {
        switch self {
        case .small: return 11
        case .title: return 16
        case .subtitle: return 15
        case .navigationTitle: return 20
        }
    }
    
    var font: UIFont {
        return attribute.primaryFont(withSize: fontSize)
    }
}

final class MockTheme: ThemeProtocol {
    func kern(forStyle style: ThemeFontStyle) -> CGFloat {
        0
    }
    
    var logoImage: UIImage { return UIImage() }
    
    var appearanceRules: AppearanceRuleSet = .empty
    
    func color(forColorPalette colorPalette: ThemeColorPalette) -> UIColor {
        return colorPalette.color
    }
    func configure(label: UILabel, withStyle style: ThemeFontStyle, customizing: ((UILabel, ThemeProtocol) -> Void)?) -> UILabel {
        label.font = style.font
        customizing?(label, self)
        return label
    }
    
    func font(forStyle style: ThemeFontStyle) -> UIFont {
        return style.font
    }
    
    func fontSize(forStyle style: ThemeFontStyle) -> CGFloat {
        return style.fontSize
    }
    
    final func cleanThemeCopy() -> MockTheme {
        return MockTheme()
    }
}

