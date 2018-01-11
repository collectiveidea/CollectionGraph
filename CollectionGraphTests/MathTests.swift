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
        
        let range: (CGFloat, CGFloat) = (min: 0.0, max: 10.234)
        let steps = 11
        
        let adjustedRange = Math.adjustRangeToWholeNumber(range, steps: steps)
        
        let expectedRange = (min: CGFloat(0), max: CGFloat(11))
        
        XCTAssertEqual(adjustedRange.min, expectedRange.min)
    }
    
}
