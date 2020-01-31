//
//  ButtonCell+Theme.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/31/20.
//

import CUIKit
import ThemeManager

public extension ButtonCell {
    func applyTheme(usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) {
        backgroundColor = theme.color(forColorPalette: .white)
        
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        
        button.backgroundColor = theme.color(forColorPalette: .competitionPurple)
        button.setTitleColor(theme.color(forColorPalette: .white), for: .normal)
    }
}

