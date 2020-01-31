//
//  ButtonCell.swift
//  CUIKit
//
//  Created by Vlad Z. on 1/30/20.
//

import UIKit

public class ButtonCell: UICollectionViewCell {
    lazy public var button: UIButton = {
        UIButton.init(type: .custom)
    }()
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor,
                                        constant: 8),
            button.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: 8),
            button.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: -8),
            button.bottomAnchor.constraint(equalTo: bottomAnchor,
                                           constant: -8)
        ])
    }
}

