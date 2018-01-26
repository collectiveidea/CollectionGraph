//
//  PPMRepo.swift
//  LotsOfDataGraph
//
//  Created by Ben Lambert on 1/2/18.
//  Copyright © 2018 collectiveidea. All rights reserved.
//

import UIKit

class PPMRepo {
    
    /* NOTE:
     For our graph we are going to plot the
     co2 on the Y axis
     and the dates on the X axis
     */
    
    var data = [PPMModel]()
    
    func getPPM(completion: @escaping (Bool) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.data = try! decoder.decode([PPMModel].self, from: PPMData().data!)
            
            completion(true)
        }
        
    }
    
    func insertData() {
        let dateString = "2017-01-05T00:04:31Z"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = dateFormatter.date(from: dateString)
        
        let newData = PPMModel(date: date!, co2: 400)
        data.insert(newData, at: 5)
    }
    
    func valueFor(indexPath: IndexPath) -> (xValue: CGFloat, yValue: CGFloat) {
        
        let co2 = CGFloat(data[indexPath.item].co2)
        let date = data[indexPath.item].date
        
        let dateToCGFloat = CGFloat(date.timeIntervalSince1970)
        
        return (dateToCGFloat, co2)
    }
    
    func getMinAndMaxCo2Values() -> (min: CGFloat, max: CGFloat) {
        let co2 = data.map {
            $0.co2
        }
        
        let min = CGFloat(co2.min() ?? 0)
        let max = CGFloat(co2.max() ?? 0)
        
        return (min, max)
    }
    
    func getMinAndMaxDateFloatValues() -> (min: CGFloat, max: CGFloat) {
        var minFloat: CGFloat = 0
        var maxFloat: CGFloat = 0
        
        let dates = data.map {
            $0.date
        }
        
        let minDate = dates.min()
        let maxDate = dates.max()
        
        if let minDate = minDate {
            minFloat = CGFloat(minDate.timeIntervalSince1970)
        }
        
        if let maxDate = maxDate {
            maxFloat = CGFloat(maxDate.timeIntervalSince1970)
        }
        
        return (minFloat, maxFloat)
    }
    
}
