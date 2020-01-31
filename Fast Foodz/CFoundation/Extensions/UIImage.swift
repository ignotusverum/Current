//
//  UIImage.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/31/20.
//

import UIKit

extension UIImageView {
    func setTintWith(gradients input: [CGColor]) {
        guard let image = image else { return }
        
        UIGraphicsBeginImageContextWithOptions(image.size,
                                               false,
                                               image.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.translateBy(x: 0,
                            y: image.size.height)
        context.scaleBy(x: 1,
                        y: -1)
        
        context.setBlendMode(.normal)
        let rect = CGRect.init(x: 0,
                               y: 0,
                               width: image.size.width,
                               height: image.size.height)
        
        let colors = input as CFArray
        let space = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: space,
                                  colors: colors,
                                  locations: nil)
        
        context.clip(to: rect,
                     mask: image.cgImage!)
        context.drawLinearGradient(gradient!,
                                   start: CGPoint(x: 0, y: 0),
                                   end: CGPoint(x: 0, y: image.size.height),
                                   options: .drawsAfterEndLocation)
        
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.image = gradientImage
    }
}
