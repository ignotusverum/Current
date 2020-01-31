//
//  ImageTitleCell+Theme.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/31/20.
//

import CUIKit
import ThemeManager

public extension ImageTitleCell {
    func applyTheme(usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) {
        backgroundColor = theme.color(forColorPalette: .white)
        
        titleLabel?.applyLabelStyle(.title(attribute: .regular), customizing: { (label, _) in
            label.textColor = theme.color(forColorPalette: .white)
        })
    }
}

