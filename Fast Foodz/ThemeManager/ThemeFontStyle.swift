//
//  ThemeFontStyle.swift
//  ThemeManager
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

public enum ThemeFontAttribute: String, CaseIterable {
    case regular = ""
    case bold = "-Bold"
}

public enum ThemeFontStyle: CaseIterable {
    case small(attribute: ThemeFontAttribute)
    case subtitle(attribute: ThemeFontAttribute)
    case title(attribute: ThemeFontAttribute)
    case navigationTitle(attribute: ThemeFontAttribute)
    
    public var attribute: ThemeFontAttribute {
        switch self {
        case let .small(attribute),
             let .subtitle(attribute),
             let .title(attribute),
             let .navigationTitle(attribute): return attribute
        }
    }
    
    public static var allCases: [ThemeFontStyle] {
        return ThemeFontAttribute.allCases.flatMap {
            [
                .small(attribute: $0),
                .subtitle(attribute: $0),
                .title(attribute: $0),
                .navigationTitle(attribute: $0)
            ]
        }
    }
}

