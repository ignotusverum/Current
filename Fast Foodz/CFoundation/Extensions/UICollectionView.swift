//
//  UICollectionView.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass,
                 forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath,
                                                      and reuseIdentifier: String = String(describing: T.self)) -> T {
        return dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                   for: indexPath) as! T
    }
    
    func registerNib<T: UICollectionViewCell>(_ cellClass: T.Type) {
        print("\(T.self) - \(cellClass.self)")
        let nib = UINib(nibName: "\(T.self)",
                        bundle: Bundle(for: T.self))
        register(nib,
                 forCellWithReuseIdentifier: "\(cellClass.self)")
    }
}

