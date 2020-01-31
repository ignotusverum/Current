//
//  ButtonStyleProtocol.swift
//  CUIKit
//
//  Created by Vlad Z. on 1/30/20.
//

import Foundation
import UIKit

// MARK: - ButtonStyleProtocol

protocol ButtonStyleProtocol {
    /// Title attributes to use for button title label.
    ///
    /// - Parameter text: Text to get attributes for.
    /// - Returns: Attributed string for text.
    func titleAttributedString(text: String) -> NSAttributedString
    
    /// Contains all properties to set in a button for its initial state.
    ///
    /// - Parameter button: Closure that returns button to stylize.
    func initialState(button: @escaping () -> UIButton)
    
    /// Contains all properties to set in a button for its normal state.
    ///
    /// - Parameter button: Closure that returns button to stylize.
    func normalState(button: @escaping () -> UIButton)
    
    /// Contains all properties to set in a button for its highlighed state.
    ///
    /// - Parameter button: Closure that returns button to stylize.
    func highlightedState(button: @escaping () -> UIButton)
    
    /// Contains all properties to set in a button for its inactive state.
    ///
    /// - Parameter button: Closure that returns button to stylize.
    func inactiveState(button: @escaping () -> UIButton)
    
    /// Gradiient colors to use in buttons gradient layer.
    ///
    /// - Returns: Array of CGColors.
    func gradientColors() -> [CGColor]
}

// MARK: - ButtonStyleProtocol Extension

extension ButtonStyleProtocol {
    func initialState(button: @escaping () -> UIButton) {
        normalState { () -> UIButton in
            button()
        }
    }
    
    func normalState(button: @escaping () -> UIButton) {
        button().alpha = 1
    }
    
    func highlightedState(button: @escaping () -> UIButton) {
        button().alpha = 0.3
    }
    
    func inactiveState(button: @escaping () -> UIButton) {
        button().alpha = 0.3
    }
    
    func gradientColors() -> [CGColor] {
        return []
    }
}

