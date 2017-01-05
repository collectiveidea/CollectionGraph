//
//  RangeFinder.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 1/5/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import Foundation

protocol RangeFinder {
    func xDataRange(graphData: [[GraphDatum]]) -> (min: CGFloat, max: CGFloat)
    func yDataRange(graphData: [[GraphDatum]], numberOfSteps steps: Int) -> (min: CGFloat, max: CGFloat)
}

extension RangeFinder {
    func xDataRange(graphData: [[GraphDatum]]) -> (min: CGFloat, max: CGFloat) {
        let xVals = graphData.flatMap {
            return $0.map { return $0.point.x }
        }

        if let min = xVals.min(), let max = xVals.max() {
            return (min, max)
        }

        return (0, 0)
    }

    func yDataRange(graphData: [[GraphDatum]], numberOfSteps steps: Int) -> (min: CGFloat, max: CGFloat) {
        let yVals = graphData.flatMap {
            return $0.map { return $0.point.y }
        }

        let maxY = yVals.max() ?? 0

        var remainder = maxY.truncatingRemainder(dividingBy: CGFloat(steps))
        if remainder.isNaN {
            remainder = 0
        }

        var max: CGFloat = 0

        if remainder == 0 {
            max = maxY
        } else {
            max = maxY - remainder + CGFloat(steps)
        }

        let min = yVals.min() ?? 0

        return (min, max)
    }

}
