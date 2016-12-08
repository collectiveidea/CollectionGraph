//
//  SideBarReusableView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 12/7/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class SideBarReusableView: UICollectionReusableView {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        backgroundColor = UIColor.red
        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        
        
    }
    
}
