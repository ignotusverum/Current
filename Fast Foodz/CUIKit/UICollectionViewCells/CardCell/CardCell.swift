//
//  CardCell.swift
//  CUIKit
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class CardCell:
    UICollectionViewCell,
    ImageDetailsCellProtocol {

    @IBOutlet public weak var detailsView: UIView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var subtitleLabel: UILabel!
    @IBOutlet public weak var bottomSubtitleLabel: UILabel!

    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var isActiveIndicatorView: UIView!
    
//    public override func prepareForReuse() {
//        super.prepareForReuse()
//        imageView.image = UIImage()
//        detailsView.backgroundColor = .white
//    }
}
