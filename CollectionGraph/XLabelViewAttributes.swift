//
//  XLabelViewAttributes.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/14/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class XLabelViewAttributes: UICollectionViewLayoutAttributes {
    var text = ""

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone)
        if let copy = copy as? XLabelViewAttributes {
            copy.text = text
        }
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? XLabelViewAttributes {
            if attributes.text == text {
                return super.isEqual(object)
            }
        }
        return false
    }

}
