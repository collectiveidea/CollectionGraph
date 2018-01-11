//
//  Math.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 6/2/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

class Math {
    
    class func percent(ofValue value: CGFloat, fromMin min: CGFloat, toMax max: CGFloat) -> CGFloat {
        
        let range = max - min
        
        var percent = (value - min) / range
        
        if percent.isNaN {
            percent = 0
        }
        
        return percent
    }
    
    class func lerp(percent: CGFloat, ofDistance distance: CGFloat) -> CGFloat {
        return distance * percent
    }
    
    class func adjustRangeToWholeNumber(_ originalRange: (min: CGFloat, max: CGFloat), steps: Int) -> (min: CGFloat, max: CGFloat) {
        
        var remainder = originalRange.max.truncatingRemainder(dividingBy: CGFloat(steps))
        if remainder.isNaN {
            remainder = 0
        }
        
        var max: CGFloat = 0
        
        if remainder == 0 {
            max = originalRange.max
        } else {
            max = originalRange.max - remainder + CGFloat(steps)
        }
        
        let min = originalRange.min
        
        return (min, max)
    }
    
}
