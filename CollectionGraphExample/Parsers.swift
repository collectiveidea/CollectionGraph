//
//  Parsers.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 1/16/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import Foundation
import CollectionGraph

protocol Parsable {
    func parse(json: [[String: Any]]) -> [[GraphDatum]]
}

struct MilesPerDayParser: Parsable {

    func parse(json: [[String: Any]]) -> [[GraphDatum]] {

        var data = [[MilesPerDayDatum]]()

        for sectionNumber in 0..<json.count {

            var sectionData = [MilesPerDayDatum]()

            guard let person = json[sectionNumber]["name"] as? String,
                let dates = json[sectionNumber]["date"] as? [String],
                let runs = json[sectionNumber]["miles"] as? [Int] else {
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

                let imageName = "user\(sectionNumber + 1)"

                if let dateTimeInterval = dateTimeInterval {
                    let point = CGPoint(x: CGFloat(dateTimeInterval), y: yRuns)

                    sectionData += [MilesPerDayDatum(point: point, name: person, imageName: imageName)]
                }
            }

            data += [sectionData]

        }
        return data
    }

}

struct TotalMilesRanParser: Parsable {

    func parse(json: [[String: Any]]) -> [[GraphDatum]] {

        var data = [[TotalMilesRanDatum]]()

        var sectionData = [TotalMilesRanDatum]()

        for sectionNumber in 0..<json.count {

            guard let person = json[sectionNumber]["name"] as? String,
                let runs = json[sectionNumber]["miles"] as? [Int] else {
                    assertionFailure("Data parsing Miles Per Day failed")
                    break
            }

            print(person)
            print(runs)

            let totalMilesRan = runs.reduce(0, {$0 + $1})

            let datum = TotalMilesRanDatum(point: CGPoint(x: sectionNumber, y: totalMilesRan), name: person, imageName: "user\(sectionNumber + 1)")

            sectionData += [datum]

        }

            data += [sectionData]

        return data
    }

}

struct SmogParser: Parsable {

    func parse(json: [[String : Any]]) -> [[GraphDatum]] {

        var data = [[SmogData]]()
        var smogData = [SmogData]()

        for number in 0..<json.count {

            guard
                let ppm = json[number]["co2"] as? Int,
                let dateString = json[number]["timestamp"] as? String
                else {
                    assertionFailure("Data Parsing Smog Data Failed")
                    break
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let date = dateFormatter.date(from: dateString)
            let dateTimeInterval = date?.timeIntervalSince1970

            if let dateTimeInterval = dateTimeInterval {
                let datum = SmogData(point: CGPoint(x: CGFloat(dateTimeInterval), y: CGFloat(ppm)))

                smogData += [datum]
            }

        }
        data += [smogData]
        return data
    }

}
