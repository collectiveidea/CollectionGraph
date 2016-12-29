//
//  LineConnectorAttributes.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/13/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class LineConnectorAttributes: UICollectionViewLayoutAttributes {
    var points:(first: CGPoint, second: CGPoint) = (first: CGPoint.zero, second: CGPoint.zero)

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone)
        if let copy = copy as? LineConnectorAttributes {
            copy.points = points
        }
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? LineConnectorAttributes {
            if attributes.points == points {
                return super.isEqual(object)
            }
        }
        return false
    }

}
