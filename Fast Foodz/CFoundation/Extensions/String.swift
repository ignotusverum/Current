//
//  String.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/28/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit
import Foundation

public extension String {
    func width(withConstrainedHeight height: CGFloat,
               font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude,
                                    height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        
        return ceil(boundingBox.width)
    }
}
