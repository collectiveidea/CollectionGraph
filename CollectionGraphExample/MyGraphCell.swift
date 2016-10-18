//
//  MyGraphCell.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/17/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit
import CollectionGraph

class MyGraphCell: UICollectionViewCell, GraphCellUpdatable {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(data: GraphData?) {
        
    }

}
