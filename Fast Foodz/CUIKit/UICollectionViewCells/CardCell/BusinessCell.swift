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

    @IBOutlet public weak var detailsView: UIView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var subtitleLabel: UILabel!
    
    @IBOutlet public weak var imageView: UIImageView!
}
