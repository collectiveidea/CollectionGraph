//
//  GraphLayoutDecorator.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 6/12/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import Foundation

internal class GraphLayoutDecorator {
    
    var collectionView: GraphCollectionView?
    
    var xMinMaxValuesCache: (min: CGFloat, max: CGFloat)?
    var yMinMaxValuesCache: (min: CGFloat, max: CGFloat)?
    
    init(collectionView: GraphCollectionView?) {
        self.collectionView = collectionView
    }
    
    internal var numberOfSections: Int {
        get {
            if let collectionView = collectionView ,let dataSource = collectionView.dataSource as? CollectionGraphDataSource {
                return dataSource.numberOfSections?(in: collectionView) ?? 1
            }
            return 1
        }
    }
    
    internal var collectionViewContentInsets: UIEdgeInsets {
        get {
            if let collectionView = collectionView {
                return collectionView.contentInset
            }
            return UIEdgeInsets.zero
        }
    }
    
    internal var paddingForXAttributes: CGFloat {
        get {
            guard let collectionView = collectionView else {
                return 0
            }
            
            if let xDelegate = collectionView.xDelegate {
                return xDelegate.bottomPaddingFor(collectionView)
            } else if collectionView.isUsingXAxisView {
                return 50 //default value if there is a xAxisView and user did not specify the bottom X padding
            }
            
            return 0
        }
    }
    
    internal var paddingForYAttributes: CGFloat {
        get {
            guard let collectionView = collectionView else {
                return 0
            }
            
            if let yDelegate = collectionView.yDelegate {
                return yDelegate.leftSidePaddingFor(collectionView)
            } else if collectionView.isUsingYAxisView {
                return 50 //default value if there is a yAxisView and user did not specify the left Y padding
            }
            
            return 0
        }
    }
    
    internal func numberOfItemsIn(section: Int) -> Int {
        
        if let collectionView = collectionView ,let dataSource = collectionView.dataSource as? CollectionGraphDataSource {
            
            return dataSource.collectionView(collectionView, numberOfItemsInSection: section)
        }
        return 0
    }
    
    internal func minAndMaxXValues() -> (min: CGFloat, max: CGFloat) {
        
        if let xMinMaxValuesCache = xMinMaxValuesCache {
            return xMinMaxValuesCache
        }
        
        if let collectionView = collectionView ,let delegate = collectionView.delegate as? CollectionGraphDelegateLayout {
            xMinMaxValuesCache = delegate.minAndMaxXValuesIn(collectionView)
            return xMinMaxValuesCache!
        }
        return (0, 0)
    }
    
    internal func minAndMaxYValues() -> (min: CGFloat, max: CGFloat) {
        
        if let yMinMaxValuesCache = yMinMaxValuesCache {
            return yMinMaxValuesCache
        }
        
        if let collectionView = collectionView ,let delegate = collectionView.delegate as? CollectionGraphDelegateLayout {
            let userDelta = delegate.minAndMaxYValuesIn(collectionView)
            let adjustedValues = adjustYDataRangeToWholeNumber(userDelta, steps: delegate.numberOfYStepsIn(collectionView))
            
            yMinMaxValuesCache = adjustedValues
            return yMinMaxValuesCache!
        }
        return (0, 0)
    }
    
    internal func adjustYDataRangeToWholeNumber(_ originalRange: (min: CGFloat, max: CGFloat), steps: Int) -> (min: CGFloat, max: CGFloat) {
        
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
    
    internal func numberOfXSteps() -> Int {
        if let collectionView = collectionView ,let delegate = collectionView.delegate as? CollectionGraphDelegateLayout {
            
            return delegate.numberOfXStepsIn(collectionView)
        }
        
        return 0
    }
    
    internal func numberOfYSteps() -> Int {
        if let collectionView = collectionView ,let delegate = collectionView.delegate as? CollectionGraphDelegateLayout {
            
            let numberOfSteps = delegate.numberOfYStepsIn(collectionView) == 0 ? 1 : delegate.numberOfYStepsIn(collectionView)
            
            return numberOfSteps
        }
        
        return 1
    }
    
    internal func distanceOfXSteps() -> CGFloat {
        if let collectionView = collectionView ,let delegate = collectionView.delegate as? CollectionGraphDelegateLayout {
            
            return delegate.distanceBetweenXStepsIn(collectionView)
        }
        
        return 0
    }
    
    internal func sizeOfCell(at indexPath: IndexPath) -> CGSize {
        if let collectionView = collectionView ,let delegate = collectionView.delegate as? CollectionGraphDelegateLayout {
            
            return delegate.graphCollectionView(collectionView, sizeForItemAt: indexPath)
        }
        return CGSize.zero
    }
    
    internal func userValue(at indexPath: IndexPath) -> (xValue: CGFloat, yValue: CGFloat) {
        if let collectionView = collectionView ,let dataSource = collectionView.dataSource as? CollectionGraphDataSource {
            
            return dataSource.collectionView(collectionView, valueFor: indexPath)
        }
        return (0, 0)
    }
    
    internal func widthOfBar(at indexPath: IndexPath) -> CGFloat {
        if let collectionView = collectionView {
            return collectionView.barGraphDelegate?.widthOfBarFor(collectionView) ?? 2
        }
        return 2
    }
    
    internal func pointInGraph(at indexPath: IndexPath) -> CGPoint {
        
        let userValue = self.userValue(at: indexPath)
        
        let size = contentSize()
        
        let xValues = minAndMaxXValues()
        let yValues = minAndMaxYValues()
        
        let minXVal = xValues.min
        let maxXVal = xValues.max
        
        let minYVal = yValues.min
        let maxYVal = yValues.max
        
        // TODO: Should be a delegate call incase there are numerous sections with different cell sizes at the first index.  For now we will just grab the first.
        let cellSize = sizeOfCell(at: IndexPath(item: 0, section: 0))
        
        let percentOnXAxis = Math.percent(ofValue: userValue.xValue,
                                          fromMin: minXVal,
                                          toMax: maxXVal)
        
        let positionX = Math.lerp(percent: percentOnXAxis,
                                  ofDistance: size.width - cellSize.width - paddingForYAttributes) + cellSize.width / 2 + paddingForYAttributes
        
        let percentOnYAxis = Math.percent(ofValue: userValue.yValue,
                                          fromMin: minYVal,
                                          toMax: maxYVal)
        
        let positionY = Math.lerp(percent: 1.0 - percentOnYAxis,
                                  ofDistance: size.height - cellSize.height - paddingForXAttributes) + cellSize.height / 2
        
        return CGPoint(x: positionX, y: positionY)
    }
    
    func contentSize() -> CGSize {
        if let layout = collectionView?.collectionViewLayout as? GraphLayout {
            return layout.collectionViewContentSize
        }
        return CGSize.zero
    }
    
}
