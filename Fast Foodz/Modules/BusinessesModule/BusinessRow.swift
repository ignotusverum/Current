//
//  BusinessRow.swift
//  BusinessesModule
//
//  Created by Vlad Z. on 1/30/20.
//

import CFoundation
import RxDataSources

struct BusinessRow: Equatable {
    let title: String
    
    let model: Business
    let type: BusinessType?
    
    init(model: Business) {
        self.model = model
        title = model.name
        type = model.type
    }
    
    func getSubtitleCopy(regularAttributes: [NSAttributedString.Key: Any],
                         priceAttributes: [NSAttributedString.Key: Any])-> NSAttributedString {
        
        var result = NSMutableAttributedString()
        let distanceCopy = LengthFormatter().string(fromValue: Double(model.distance),
                                                    unit: .mile)
        let subtitleCopy = "$$$$ • \(distanceCopy)"
        result = NSMutableAttributedString(string: subtitleCopy, attributes: regularAttributes)
        
        if let pricePoint = model.pricePoint {
            result.addAttributes(priceAttributes, range: NSMakeRange(0, pricePoint.rawValue.count))
        }
        
        return result
    }
}
