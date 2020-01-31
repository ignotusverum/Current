//
//  CGSize.swift
//  CUIKit
//
//  Created by Vlad Z. on 1/30/20.
//

import UIKit

public extension CGSize {
    static func > (_ lhs: CGSize,
                   _ rhs: CGSize) -> Bool {
        return lhs.width > rhs.width || lhs.height > rhs.height
    }
}
