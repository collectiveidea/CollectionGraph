//
//  XLabelReusableView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/5/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

internal class XLabelLayoutAttributes: UICollectionViewLayoutAttributes {
    var text: String = ""
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone)
        if let copy = copy as? XLabelLayoutAttributes {
            copy.text = text
        }
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? XLabelLayoutAttributes {
            if attributes.text == text {
                return super.isEqual(object)
            }
        }
        return false
    }
}

public class XLabelReusableView: UICollectionReusableView {
    
    public var label = UILabel()
    
    var text: String = "•" {
        didSet {
            label.text = text
            label.sizeToFit()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12)
        label.sizeToFit()
        addSubview(label)
        
        clipsToBounds = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? XLabelLayoutAttributes {
            self.text = attributes.text
        }
    }
    
}
