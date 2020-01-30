//
//  ThemeContainer.swift
//  ThemeManager
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class ThemeContainer {
    public static var defaultTheme: ThemeProtocol! {
        didSet {
            if let old = oldValue {
                old.appearanceRules.revert()
            }
            
            UIApplication.shared.windows.forEach { window in
                window.applyTheme(defaultTheme)
            }
        }
    }
}

