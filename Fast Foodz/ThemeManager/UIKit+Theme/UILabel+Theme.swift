//
//  UILabel+theme.swift
//  ThemeManager
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public extension UILabel {
    func applyLabelStyle(_ style: ThemeFontStyle, usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme, customizing: ((UILabel, ThemeProtocol) -> Void)? = nil) {
        theme.configure(label: self, withStyle: style, customizing: customizing)
    }
}

public extension Array where Element: UILabel {
    func applyLabelStyle(_ style: ThemeFontStyle, usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme, customizing: ((UILabel, ThemeProtocol) -> Void)? = nil) {
        forEach {
            theme.configure(label: $0, withStyle: style, customizing: customizing)
        }
    }
}
