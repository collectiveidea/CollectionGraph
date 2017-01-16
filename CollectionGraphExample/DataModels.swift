//
//  DataModels.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 1/16/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import Foundation
import CollectionGraph

struct SmogData: GraphDatum {
    // x = dates
    // y = Particles Per Million
    var point: CGPoint
}

struct MilesPerDayDatum: GraphDatum {
    // x = dates ran
    // y = miles that date
    var point: CGPoint
    var name: String
    var imageName: String
}
