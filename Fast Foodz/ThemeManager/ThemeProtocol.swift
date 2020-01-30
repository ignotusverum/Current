//
//  ThemeProtocol.swift
//  ThemeManager
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public protocol Themed: UITraitEnvironment {
    func applyTheme()
}

public protocol ThemeProtocol: class {
    var appearanceRules: AppearanceRuleSet { get }
    
    // MARK: Colors
    
    func color(forColorPalette colorPalette: ThemeColorPalette) -> UIColor
    
    // MARK: Fonts
    
    func font(forStyle style: ThemeFontStyle) -> UIFont
    func kern(forStyle style: ThemeFontStyle) -> CGFloat
    
    // MARK: Labels
    
    @discardableResult
    func configure(label: UILabel, withStyle style: ThemeFontStyle, customizing: ((UILabel, ThemeProtocol) -> Void)?) -> UILabel
}

