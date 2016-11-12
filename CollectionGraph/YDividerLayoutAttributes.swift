//
//  YDividerLayoutAttributes.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/13/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class YDividerLayoutAttributes: UICollectionViewLayoutAttributes {
    var text: String = ""
    var inset: CGFloat = 0

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone)
        if let copy = copy as? YDividerLayoutAttributes {
            copy.text = text
            copy.inset = inset
        }
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? YDividerLayoutAttributes {
            if attributes.text == text && attributes.inset == inset {
                return super.isEqual(object)
            }
        }
        return false
    }

}
