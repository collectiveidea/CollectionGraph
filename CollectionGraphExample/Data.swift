//
//  Data.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/14/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit
import CollectionGraph

struct MilesPerDayDatum: GraphDatum {
    // x = dates ran
    // y = miles that date
    var point: CGPoint
    var name: String
}

class GraphDataService {

    var completion: (([[MilesPerDayDatum]]) -> Void)?

    func fetchMilesPerDayDatum(completion: @escaping ([[MilesPerDayDatum]]) -> Void) {

        self.completion = completion

        // Simulate server wait time
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {

            self.serializeJsonFile()

        })
    }

    func serializeJsonFile() {

        let path = Bundle.main.path(forResource: "MilesPerDayData", ofType: "json")

        if let path = path {

            do {
                let data = try Data(referencing: NSData(contentsOfFile: path))

                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]]

                if let json = json {
                    createMilesPerDayDatum(json: json)
                }

            } catch {
                print("Missing the .json file")
            }
        }
    }

    func createMilesPerDayDatum(json: [[String: Any]]) {

        let data = parsejson(json: json)

        completion?(data)
    }

    func parsejson(json: [[String: Any]]) -> [[MilesPerDayDatum]] {

        var data = [[MilesPerDayDatum]]()

        for number in 0..<json.count {

            var sectionData = [MilesPerDayDatum]()

            guard let person = json[number]["name"] as? String,
                let dates = json[number]["date"] as? [String],
                let runs = json[number]["miles"] as? [Int] else {
                    assertionFailure("Data parsing Miles Per Day failed")
                    break
            }

            print(person)
            print(dates)
            print(runs)

            for number in 0..<dates.count {

                let xDateString = dates[number]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                let date = dateFormatter.date(from: xDateString)
                let dateTimeInterval = date?.timeIntervalSince1970

                let yRuns: CGFloat = CGFloat(runs[number])

                if let dateTimeInterval = dateTimeInterval {
                    let point = CGPoint(x: CGFloat(dateTimeInterval), y: yRuns)

                    sectionData += [MilesPerDayDatum(point: point, name: person)]
                }
            }

            data += [sectionData]

        }
        return data
    }

}
