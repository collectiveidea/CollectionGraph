//
//  BarGraphReusableView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 11/29/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

open class BarGraphReusableView: UICollectionReusableView {
    
    public var topColor: UIColor = UIColor.darkText
    public var bottomColor: UIColor = UIColor.darkGray
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
        
}