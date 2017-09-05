//
//  MilesPerDayData.swift
//  CollectionGraphExample
//
//  Created by Ben Lambert on 9/1/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

class MilesPerDayData {
    let data = """
    [{
    "name": "Janice Anderson",
    "date": [
    "2017-01-01T00:00:00Z",
    "2017-01-02T00:00:00Z",
    "2017-01-03T00:00:00Z",
    "2017-01-04T00:00:00Z",
    "2017-01-05T00:00:00Z",
    "2017-01-06T00:00:00Z",
    "2017-01-07T00:00:00Z"
    ],
    "miles": [
    10,
    8,
    3,
    2,
    8,
    7,
    3
    ]
    }, {
    "name": "Scott Alvarez",
    "date": [
    "2017-01-01T00:00:00Z",
    "2017-01-02T00:00:00Z",
    "2017-01-03T00:00:00Z",
    "2017-01-04T00:00:00Z",
    "2017-01-05T00:00:00Z",
    "2017-01-06T00:00:00Z",
    "2017-01-07T00:00:00Z"
    ],
    "miles": [
    8,
    2,
    4,
    7,
    2,
    3,
    4
    ]
    }, {
    "name": "Beverly Baker",
    "date": [
    "2017-01-01T00:00:00Z",
    "2017-01-02T00:00:00Z",
    "2017-01-03T00:00:00Z",
    "2017-01-04T00:00:00Z",
    "2017-01-05T00:00:00Z",
    "2017-01-06T00:00:00Z",
    "2017-01-07T00:00:00Z"
    ],
    "miles": [
    0,
    9,
    10,
    9,
    4,
    10,
    2
    ]
    }, {
    "name": "Ron Dingle",
    "date": [
    "2017-01-01T00:00:00Z",
    "2017-01-02T00:00:00Z",
    "2017-01-03T00:00:00Z",
    "2017-01-04T00:00:00Z",
    "2017-01-05T00:00:00Z",
    "2017-01-06T00:00:00Z",
    "2017-01-07T00:00:00Z"
    ],
    "miles": [
    9,
    7,
    9,
    8,
    8,
    5,
    10
    ]
    }]
""".data(using: .utf8)
}

struct MilesPerDayModel: Decodable {
    
    var name: String
    var date: [Date]
    var miles: [Int]
    
}

class MilesPerDayRepo  {
    
    /* NOTE:
     For our graph we are going to plot the
     miles ran on the Y axis
     and the dates on the X axis
     
     Each person will be a different section in our graph
     */
    
    var data = [MilesPerDayModel]()
    
    init() {
        getMilesPerDay()
    }
    
    func getMilesPerDay() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        data = try! decoder.decode([MilesPerDayModel].self, from: MilesPerDayData().data!)
    }
    
    func maxMileageRan() -> Int {
        let maxNumbersForAllData = data.map {
            $0.miles.max()
        }
        let maxNumbersExcludingNils = maxNumbersForAllData.flatMap { $0 }
        let maxInt = maxNumbersExcludingNils.max()
        
        return maxInt ?? 0
    }
    
    func  numberOfItemsIn(section: Int) -> Int {
        let milesPerDayData = data[section]
        return milesPerDayData.date.count
    }
    
    func valueFor(indexPath: IndexPath) -> (xValue: CGFloat, yValue: CGFloat) {
        let milesPerDayData = data[indexPath.section]
        
        let miles = CGFloat(milesPerDayData.miles[indexPath.item])
        let date = milesPerDayData.date[indexPath.item]
        
        let dateToCGFloat = CGFloat(date.timeIntervalSince1970)
        
        return (dateToCGFloat, miles)
    }
    
    func maxDateValue() -> CGFloat {
        let maxDatesForAllData = data.map {
            $0.date.max()
        }
        
        let maxDatesExcludingNils = maxDatesForAllData.flatMap { $0 }
        if let maxDate = maxDatesExcludingNils.max() {
            let maxDateCGFloat = CGFloat(maxDate.timeIntervalSince1970)
            
            return maxDateCGFloat
        }
        
        return 0
    }
    
    func minDateValue() -> CGFloat {
        let minDatesForAllData = data.map {
            $0.date.min()
        }
        
        let minDatesExcludingNils = minDatesForAllData.flatMap { $0 }
        if let minDate = minDatesExcludingNils.min() {
            let minDateCGFloat = CGFloat(minDate.timeIntervalSince1970)
            
            return minDateCGFloat
        }
        
        return 0
    }
    
}
