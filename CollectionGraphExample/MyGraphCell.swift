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

    func update(data: GraphData?) {
        backgroundColor = UIColor.red
    }

}
