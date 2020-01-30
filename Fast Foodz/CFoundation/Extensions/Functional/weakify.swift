//
//  weakify.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public func weakify<Obj: AnyObject, Return>(_ object: Obj, _ transform: @escaping (Obj) -> Return) -> () -> Return? {
    return { [weak object] in
        guard let strongObj = object else { return nil }
        return transform(strongObj)
    }
}

public func weakify<Obj: AnyObject, T, Return>(_ object: Obj, _ transform: @escaping (Obj, T) -> Return) -> (T) -> Return? {
    return { [weak object] element in
        guard let strongObj = object else { return nil }
        return transform(strongObj, element)
    }
}

public func weakify<Obj: AnyObject, T, Return>(_ object: Obj, default: Return, _ transform: @escaping (Obj, T) -> Return) -> (T) -> Return {
    return { [weak object] element in
        guard let strongObj = object else { return `default` }
        return transform(strongObj, element)
    }
}
