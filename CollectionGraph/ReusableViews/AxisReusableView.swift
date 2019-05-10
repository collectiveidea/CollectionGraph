//
//  XLabelReusableView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/5/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

internal class AxisLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var value: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone)
        if let copy = copy as? AxisLayoutAttributes {
            copy.value = value
        }
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? AxisLayoutAttributes {
            if attributes.value == value {
                return super.isEqual(object)
            }
        }
        return false
    }
    
}

open class AxisReusableView: UICollectionReusableView {

    public var value: CGFloat = 0.0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? AxisLayoutAttributes {
            value = attributes.value
        }
    }

}
