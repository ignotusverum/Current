//
//  TitleCell.swift
//  CUIKit
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit
import Foundation

public class TitleCell:
    UICollectionViewCell,
    TitleViewProtocol {
    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        defaultTitleLayout()
    }
}

