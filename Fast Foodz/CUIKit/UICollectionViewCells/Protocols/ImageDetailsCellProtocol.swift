//
//  ImageDetailsCellProtocol.swift
//  CUIKit
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

@objc
public protocol ImageDetailsCellProtocol where Self: UICollectionViewCell {
    var imageView: UIImageView! { get set }
    
    var detailsView: UIView! { get set }
    var titleLabel: UILabel! { get set }
    var subtitleLabel: UILabel! { get set }
    var bottomSubtitleLabel: UILabel! { get set }
}
