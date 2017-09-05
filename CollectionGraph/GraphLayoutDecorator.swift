//
//  GraphLayoutDecorator.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 6/12/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import Foundation

internal class GraphLayoutDecorator {
    
    var collectionView: UICollectionView?
    
    var xMinMaxValuesCache: (min: CGFloat, max: CGFloat)?
    var yMinMaxValuesCache: (min: CGFloat, max: CGFloat)?
    
    init(collectionView: UICollectionView?) {
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
            yMinMaxValuesCache = delegate.minAndMaxYValuesIn(collectionView)
            return yMinMaxValuesCache!
        }
        return (0, 0)
    }
    
    internal func numberOfXSteps() -> Int {
        if let collectionView = collectionView ,let delegate = collectionView.delegate as? CollectionGraphDelegateLayout {
            
            return delegate.numberOfXStepsIn(collectionView)
        }
        
        return 0
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
    
    internal func pointInGraph(at indexPath: IndexPath) -> CGPoint {
        
        let userValue = self.userValue(at: indexPath)
        
        let size = collectionView?.collectionViewLayout.collectionViewContentSize ?? CGSize.zero
        
        let xValues = minAndMaxXValues()
        let yValues = minAndMaxYValues()
        
        let minXVal = xValues.min
        let maxXVal = xValues.max
        
        let minYVal = yValues.min
        let maxYVal = yValues.max
        
        let percentOnXAxis = Math.percent(ofValue: userValue.xValue, fromMin: minXVal, toMax: maxXVal)
        let positionX = Math.lerp(percent: percentOnXAxis, ofDistance: size.width)
        
        let percentOnYAxis = Math.percent(ofValue: userValue.yValue, fromMin: minYVal, toMax: maxYVal)
        let positionY = Math.lerp(percent: percentOnYAxis, ofDistance: size.height)
        
        return CGPoint(x: positionX, y: positionY)
    }
    
    func contentWidth() -> CGFloat {
        if let layout = collectionView?.collectionViewLayout {
            return layout.collectionViewContentSize.width
        }
        return 0.0
    }
    
    func textForXLabelFrom(_ value: CGFloat) -> String? {
        if let collectionView = collectionView as? GraphCollectionView,let delegate = collectionView.xLabelDelegate {
        
            return delegate.collectionView(collectionView, TextFromValue: value)
        }
        return nil
    }
    
}
