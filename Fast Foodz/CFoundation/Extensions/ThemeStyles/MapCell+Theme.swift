//
//  MapCell+Theme.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/31/20.
//

import CUIKit
import ThemeManager

public extension MapCell {
    func applyTheme(usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) {
        backgroundColor = theme.color(forColorPalette: .white)
        
        mapView?.layer.cornerRadius = 12
        mapView?.clipsToBounds = true
        
        renderer?.strokeColor = theme.color(forColorPalette: .bluCepheus)
        renderer?.lineWidth = 4
    }
}
