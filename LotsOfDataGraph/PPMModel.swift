//
//  PPMModel.swift
//  LotsOfDataGraph
//
//  Created by Ben Lambert on 1/2/18.
//  Copyright © 2018 collectiveidea. All rights reserved.
//

import Foundation

struct PPMModel: Decodable {
    
    var date: Date
    var co2: Int
    
    enum CodingKeys: String, CodingKey {
        case date = "timestamp"
        case co2
    }
    
}
