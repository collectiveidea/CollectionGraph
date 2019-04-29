//
//  GraphLayoutDecorator.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 6/12/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

internal class GraphLayoutDecorator {
    
    unowned var collectionGraph: CollectionGraph
    
    var xMinMaxValuesCache: MinMaxValues?
    var yMinMaxValuesCache: MinMaxValues?
    
    init(collectionGraph: CollectionGraph) {
        self.collectionGraph = collectionGraph
    }
    
    internal var numberOfSections: Int {
        get {
            return collectionGraph.collectionView.dataSource?.numberOfSections?(in: collectionGraph.collectionView) ?? 1
        }
    }
    
    internal var collectionViewContentInsets: UIEdgeInsets {
        get {
            return collectionGraph.collectionView.contentInset
        }
    }
    
    internal var paddingForXAttributes: CGFloat {
        get {
            if let xDelegate = collectionGraph.xDelegate {
                return xDelegate.bottomPaddingFor(collectionGraph.collectionView)
            } else if collectionGraph.isUsingXAxisView {
                return 50 //default value if there is a xAxisView and user did not specify the bottom X padding
            }
            return 0
        }
    }
    
    internal var paddingForYAttributes: CGFloat {
        get {
            if let yDelegate = collectionGraph.yDelegate {
                return yDelegate.leftSidePaddingFor(collectionGraph.collectionView)
            } else if collectionGraph.isUsingYAxisView {
                return 50 //default value if there is a yAxisView and user did not specify the left Y padding
            }
            return 0
        }
    }
    
    internal func numberOfItemsIn(section: Int) -> Int {
        if let dataSource = collectionGraph.collectionGraphDataSource {
            return dataSource.collectionView(collectionGraph.collectionView, numberOfItemsInSection: section)
        }
        return 0
    }
    
    internal func minAndMaxXValues() -> MinMaxValues {
        
        if let xMinMaxValuesCache = xMinMaxValuesCache {
            return xMinMaxValuesCache
        }
        
        if let delegate = collectionGraph.collectionView.delegate as? CollectionGraphDelegateLayout {
            xMinMaxValuesCache = delegate.minAndMaxXValuesIn(collectionGraph.collectionView)
            return xMinMaxValuesCache!
        }
        return MinMaxValues(min: 0, max: 0)
    }
    
    internal func minAndMaxYValues() -> MinMaxValues {
        
        if let yMinMaxValuesCache = yMinMaxValuesCache {
            return yMinMaxValuesCache
        }
        
        if let delegate = collectionGraph.collectionView.delegate as? CollectionGraphDelegateLayout {
            let userDelta = delegate.minAndMaxYValuesIn(collectionGraph.collectionView)
            
            if collectionGraph.usesWholeNumbersOnYAxis {
                let adjustedValues = Math.adjustRangeToWholeNumber(userDelta, steps: delegate.numberOfYStepsIn(collectionGraph.collectionView))
                yMinMaxValuesCache = adjustedValues
            } else {
                yMinMaxValuesCache = userDelta
            }
            
            return yMinMaxValuesCache!
        }
        return MinMaxValues(min: 0, max: 0)
    }
    
    internal func numberOfXSteps() -> Int {
        if let delegate = collectionGraph.collectionView.delegate as? CollectionGraphDelegateLayout {
            return delegate.numberOfXStepsIn(collectionGraph.collectionView)
        }
        return 0
    }
    
    internal func numberOfYSteps() -> Int {
        if let delegate = collectionGraph.collectionView.delegate as? CollectionGraphDelegateLayout {
            let numberOfSteps = delegate.numberOfYStepsIn(collectionGraph.collectionView) == 0 ? 1 : delegate.numberOfYStepsIn(collectionGraph.collectionView)
            return numberOfSteps
        }
        return 1
    }
    
    internal func distanceOfXSteps() -> CGFloat {
        if let delegate = collectionGraph.collectionView.delegate as? CollectionGraphDelegateLayout {
            return delegate.distanceBetweenXStepsIn(collectionGraph.collectionView)
        }
        return 0
    }
    
    internal func sizeOfCell(at indexPath: IndexPath) -> CGSize {
        if let delegate = collectionGraph.collectionView.delegate as? CollectionGraphDelegateLayout {
            return delegate.graphCollectionView(collectionGraph.collectionView, sizeForItemAt: indexPath)
        }
        return CGSize.zero
    }
    
    internal func userValue(at indexPath: IndexPath) -> GraphValue {
        if let dataSource = collectionGraph.collectionGraphDataSource {
            return dataSource.collectionView(collectionGraph.collectionView, valueFor: indexPath)
        }
        return GraphValue(0, 0)
    }
    
    internal func widthOfBar(at indexPath: IndexPath) -> CGFloat {
        return collectionGraph.barGraphDelegate?.widthOfBarFor(collectionGraph.collectionView) ?? 2
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
        if let layout = collectionGraph.collectionView.collectionViewLayout as? GraphLayout {
            return layout.collectionViewContentSize
        }
        return CGSize.zero
    }
    
}
