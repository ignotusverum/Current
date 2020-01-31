//
//  CardCell+Theme.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import CUIKit
import ThemeManager

public extension BusinessCell {
    func applyTheme(usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) {
        backgroundColor = theme.color(forColorPalette: .white)
        
        subtitleLabel.applyLabelStyle(.title(attribute: .regular),
                                      usingTheme: theme,
                                      customizing: { (label, _) in
                                        label.textColor = theme.color(forColorPalette: .grey300)
        })
        
        [titleLabel].applyLabelStyle(.subtitle(attribute: .bold),
                                              usingTheme: theme)
        
        setBorder(.bottom,
                  withColor: theme.color(forColorPalette: .black),
                  andThickness: 2)
    }
}
