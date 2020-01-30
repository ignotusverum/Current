//
//  UIColor+Theme.swift
//  ThemeManager
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

extension UIColor {
    public static func color(forPalette palette: ThemeColorPalette, usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) -> UIColor {
        return theme.color(forColorPalette: palette)
    }
}
