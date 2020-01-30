//
//  ScrollBarView+Rx.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/28/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import CUIKit

public extension Reactive where Base: ScrollBarView {
    var contentSize: Binder<CGSize> {
        return Binder(base) { scrollBar, contentSize in
            scrollBar.contentSize = contentSize
        }
    }
    
    var contentOffset: Binder<CGPoint> {
        return Binder(base) { scrollBar, contentOffset in
            scrollBar.contentOffset = contentOffset
        }
    }
}

