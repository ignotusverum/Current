//
//  BusinessCell.swift
//  CUIKit
//
//  Created by Vlad Z. on 1/30/20.
//

import UIKit
import Foundation

public class BusinessCell:
    UICollectionViewCell,
    ImageDetailsCellProtocol {

    @IBOutlet public weak var chevroneImageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var subtitleLabel: UILabel!
    
    @IBOutlet public weak var imageView: UIImageView!
    
    public func configureCopy(with title: String,
                              subtitleAttributedString: NSAttributedString) {
        titleLabel.text = title
        subtitleLabel.attributedText = subtitleAttributedString
    }
}
