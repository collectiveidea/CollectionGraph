//
//  GraphLine.swift
//  LotsOfDataGraph
//
//  Created by Ben Lambert on 5/10/19.
//  Copyright © 2019 collectiveidea. All rights reserved.
//

import UIKit
import CollectionGraph

class GraphLine: BaseLineGraphReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        line.lineWidth = 1
        line.strokeColor = UIColor.purple.cgColor
        line.shadowOpacity = 0.2
        line.shadowOffset = CGSize(width: 2, height: 12)
        line.shadowRadius = 2
        line.shadowColor = UIColor.black.cgColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
