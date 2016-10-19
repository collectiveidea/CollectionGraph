//
//  GraphLayoutConfig.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/18/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit
import CollectionGraph

struct GraphLayoutConfig: LineGraphLayoutConfigurable {
    var ySteps: Int = 6
    var xSteps: Int = 3
    var graphWidth: CGFloat?
    var straightLines: Bool = true

    func cellSize(fromData data: GraphData) -> CGSize {

        if let data = data as? Data {
            if data.information["los angeles"] == data.point {
                return CGSize(width: 14, height: 14)
            }
        }

        return CGSize(width: 5, height: 5)
    }

    func lineWidth(fromData data: GraphData) -> CGFloat {
        return 3
    }

}
