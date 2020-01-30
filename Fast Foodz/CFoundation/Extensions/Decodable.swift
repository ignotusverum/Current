//
//  Decodable.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct TitleKey: CodingKey {
    public let stringValue: String
    public init?(stringValue: String) { self.stringValue = stringValue }
    public var intValue: Int? { return nil }
    public init?(intValue: Int) { return nil }
}

public extension Decoder {
    func currentTitle() throws -> String {
        guard let titleKey = codingPath.last as? TitleKey else {
            throw DecodingError.dataCorrupted(.init(codingPath: codingPath,
                                                    debugDescription: "Not in titled container"))
        }
        return titleKey.stringValue
    }
}

public extension Decoder {
    func decodeTitledElements<Element: Decodable>(_ type: Element.Type) throws -> [Element] {
        let titles = try container(keyedBy: TitleKey.self)
        return try titles.allKeys.map { title in
            try titles.decode(Element.self, forKey: title)
        }
    }
}

public protocol TitleDecodable: Decodable {
    associatedtype Element: Decodable
    init(title: String,
         elements: [Element])
}

public extension TitleDecodable {
    init(from decoder: Decoder) throws {
        self.init(title: try decoder.currentTitle(),
                  elements: try decoder.decodeTitledElements(Element.self))
    }
}
