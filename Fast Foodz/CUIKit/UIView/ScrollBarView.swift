//
//  ScrollBarView.swift
//  CUIKit
//
//  Created by Vlad Z. on 1/28/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class ScrollBarView: UIView {
    public var foregroundColor: UIColor = .black {
        didSet {
            barShape.fillColor = foregroundColor.cgColor
        }
    }
    
    public var contentOffset: CGPoint = .zero {
        didSet { updateBar() }
    }
    
    public var contentSize: CGSize = .zero {
        didSet { updateBar() }
    }
    
    private let barShape: CAShapeLayer = CAShapeLayer()
    
    public override func layoutSubviews() {
        layer.cornerRadius = bounds.height / 2.0
        updateBar()
        super.layoutSubviews()
    }
    
    private var widthContentSizeRatio: CGFloat { return (superview?.bounds.width ?? bounds.width) / max(contentSize.width, bounds.width) }
    private var barShapeSize: CGSize { return CGSize(width: (superview?.bounds.width ?? bounds.width) * widthContentSizeRatio, height: bounds.height) }
    
    private func updateBar() {
        let offset = CGPoint(x: contentOffset.x * widthContentSizeRatio, y: 0)
        let rect = CGRect(origin: offset, size: barShapeSize)
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: bounds.height / 2.0)
        barShape.path = path.cgPath
        
        if barShape.superlayer == nil {
            barShape.fillColor = foregroundColor.cgColor
            layer.masksToBounds = true
            layer.addSublayer(barShape)
        }
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        updateBar()
    }
}

