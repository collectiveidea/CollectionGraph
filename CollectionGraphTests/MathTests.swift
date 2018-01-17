//
//  MathTests.swift
//  CollectionGraphTests
//
//  Created by Ben Lambert on 1/11/18.
//  Copyright © 2018 collectiveidea. All rights reserved.
//

import XCTest

class MathTests: XCTestCase {

    func testRangeToWholeNumber() {
        
        let range: (CGFloat, CGFloat) = (min: 3.5, max: 13.234)
        let steps = 10
        
        let adjustedRange = Math.adjustRangeToWholeNumber(range, steps: steps)
        print("Adjusted Range: \(adjustedRange)")
        
        let expectedAmoutPerStep = (adjustedRange.max - adjustedRange.min) / CGFloat(steps)
        print("Amount per step: \(expectedAmoutPerStep)")
        
        XCTAssertEqual(0, expectedAmoutPerStep.truncatingRemainder(dividingBy: 2))
    }
    
}
