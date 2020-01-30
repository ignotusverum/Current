//
//  TitleViewProtocol.swift
//  CUIKit
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public protocol TitleViewProtocol where Self: UICollectionViewCell {
    var title: String { get set }
    var titleLabel: UILabel { get }
}

public extension TitleViewProtocol {
    var titleViewOffset: CGFloat { 15 }
    func defaultTitleLayout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                            constant: titleViewOffset),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                               constant: -titleViewOffset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: titleViewOffset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -titleViewOffset)
        ])
    }
}


