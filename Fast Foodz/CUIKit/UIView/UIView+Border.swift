//
//  UIView+Border.swift
//  CUIKit
//
//  Created by Vlad Z. on 1/30/20.
//

import UIKit

private var viewForBorderHandle: UInt8 = 0
private var thicknessConstraintForBorderHandle: UInt8 = 0

public extension UIView {
    private(set) var viewForBorder: [Border: UIView] {
        get {
            return objc_getAssociatedObject(self, &viewForBorderHandle) as? [Border: UIView] ?? [Border: UIView]()
        }
        set {
            objc_setAssociatedObject(self, &viewForBorderHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private(set) var thicknessConstraintForBorder: [Border: NSLayoutConstraint] {
        get {
            return objc_getAssociatedObject(self, &thicknessConstraintForBorderHandle) as? [Border: NSLayoutConstraint] ?? [Border: NSLayoutConstraint]()
        }
        set {
            objc_setAssociatedObject(self, &thicknessConstraintForBorderHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    enum Border: Int, CaseIterable {
        case top, right, bottom, left
    }
    
    func setBorder(_ border: Border, withColor color: UIColor, andThickness thickness: CGFloat) {
        let borderView = viewForBorder[border, default: UIView()]
        
        borderView.backgroundColor = color
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        guard borderView.superview != self else {
            thicknessConstraintForBorder[border]?.constant = thickness
            return
        }
        
        addSubview(borderView)
        
        switch border {
        case .top:
            let thicknessConstraint = borderView.heightAnchor.constraint(equalToConstant: thickness)
            NSLayoutConstraint.activate(
                [borderView.topAnchor.constraint(equalTo: topAnchor),
                 borderView.leftAnchor.constraint(equalTo: leftAnchor),
                 borderView.rightAnchor.constraint(equalTo: rightAnchor),
                 thicknessConstraint]
            )
            thicknessConstraintForBorder[border] = thicknessConstraint
        case .bottom:
            let thicknessConstraint = borderView.heightAnchor.constraint(equalToConstant: thickness)
            NSLayoutConstraint.activate(
                [borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
                 borderView.leftAnchor.constraint(equalTo: leftAnchor),
                 borderView.rightAnchor.constraint(equalTo: rightAnchor),
                 thicknessConstraint]
            )
            thicknessConstraintForBorder[border] = thicknessConstraint
        case .left:
            let thicknessConstraint = borderView.widthAnchor.constraint(equalToConstant: thickness)
            NSLayoutConstraint.activate(
                [borderView.topAnchor.constraint(equalTo: topAnchor),
                 borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
                 borderView.leftAnchor.constraint(equalTo: leftAnchor),
                 thicknessConstraint]
            )
            thicknessConstraintForBorder[border] = thicknessConstraint
        case .right:
            let thicknessConstraint = borderView.widthAnchor.constraint(equalToConstant: thickness)
            NSLayoutConstraint.activate(
                [borderView.topAnchor.constraint(equalTo: topAnchor),
                 borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
                 borderView.rightAnchor.constraint(equalTo: rightAnchor),
                 thicknessConstraint]
            )
            thicknessConstraintForBorder[border] = thicknessConstraint
        }
        
        viewForBorder[border] = borderView
    }
    
    func setBorders(_ borders: [Border], withColor color: UIColor, andThickness thickness: CGFloat) {
        borders.forEach {
            setBorder($0, withColor: color, andThickness: thickness)
        }
    }
    
    func setVisibleBordersColor(_ color: UIColor) {
        viewForBorder.values.forEach {
            $0.backgroundColor = color
        }
    }
    
    func setVisibleBordersThickness(_ thickness: CGFloat) {
        viewForBorder.keys.forEach {
            thicknessConstraintForBorder[$0]?.constant = thickness
        }
    }
    
    func hideBorder(_ border: Border) {
        viewForBorder[border]?.alpha = 0
    }
    
    func hideBorders(_ borders: [Border]) {
        borders.forEach(hideBorder)
    }
    
    func unhideBorder(_ border: Border) {
        viewForBorder[border]?.alpha = 1
    }
    
    func unhideBorders(_ borders: [Border]) {
        borders.forEach(unhideBorder)
    }
    
    func removeBorder(_ border: Border) {
        viewForBorder[border]?.removeFromSuperview()
        thicknessConstraintForBorder[border] = nil
    }
    
    func removeBorders(_ borders: [Border]) {
        borders.forEach(removeBorder)
    }
    
    func removeAllBorders() {
        viewForBorder.keys.forEach(removeBorder)
    }
}
