//
//  SelectionListView.swift
//  CUIKit
//
//  Created by Vlad Z. on 1/28/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public struct SelectionListViewConfig {
    public var title: String
    public var cellSize: CGFloat
    
    public init(title: String,
                cellSize: CGFloat) {
        self.title = title
        self.cellSize = cellSize
    }
}

public class SelectionListView: UIView {
    lazy var  collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        
        collectionView.register(TitleCell.self,
                                forCellWithReuseIdentifier: "\(TitleCell.self)")
        
        return collectionView
    }()
    
    public var datasource: [SelectionListViewConfig] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public init(datasource: [SelectionListViewConfig] = []) {
        super.init(frame: .zero)
        
        self.datasource = datasource
        datasourceSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func datasourceSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        
        collectionView.backgroundColor = .magenta
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension SelectionListView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let config = datasource[indexPath.row]
        return CGSize(width: config.cellSize,
                      height: collectionView.frame.height)
    }
}

extension SelectionListView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int { datasource.count > 0 ? 1 : 0 }
    
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int { datasource.count }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let config = datasource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleCell.self)", for: indexPath) as! TitleCell
        
        cell.title = config.title
        
        return cell
    }
}
