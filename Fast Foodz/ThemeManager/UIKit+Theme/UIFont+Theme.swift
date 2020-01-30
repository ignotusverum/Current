//
//  UIFont+Theme.swift
//  ThemeManager
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit


public extension UIFont {
    static func font(forStyle style: ThemeFontStyle, usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) -> UIFont {
        return theme.font(forStyle: style)
    }
}

