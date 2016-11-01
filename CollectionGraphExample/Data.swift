//
//  Data.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/14/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit
import CollectionGraph

struct Data: GraphDatum {
    var point: CGPoint
    var information: [String: CGPoint]
}

struct ExampleDataFromServer {
    let json = [
        [
            "city": "chicago",
            "population": "100000"
        ],
        [
            "city": "los angeles",
            "population": "130000"
        ],
        [
            "city": "grand rapids",
            "population": "20000"
        ]
    ]
}

class Parser {

    class func parseExampleData(data: [[String: String]]) -> [[Data]] {

        var dataAry: [[Data]] = [[]]

        for (index, item) in data.enumerated() {

            let population = CGFloat((item["population"]! as NSString).floatValue)
            let city = item["city"]!
            
            let point = CGPoint(x: CGFloat(index), y: population)

            let data = Data(point: point, information: [city: point])

            dataAry[0].append(data)
        }

        return dataAry
    }

}
