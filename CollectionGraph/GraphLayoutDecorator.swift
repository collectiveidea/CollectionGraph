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
    
    init(collectionView: UICollectionView?) {
        self.collectionView = collectionView
    }
    
    internal var numberOfSections: Int {
        get {
            if let collectionView = collectionView ,let dataSource = collectionView.dataSource as? CollectionGraphDataSource {
                return dataSource.numberOfSections?(in: collectionView) ?? 0
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
        
        if let collectionView = collectionView ,let delegate = collectionView.delegate as? CollectionGraphDelegateLayout {
            
            return delegate.minAndMaxXValuesIn(collectionView)
        }
        return (0, 0)
    }
    
    internal func minAndMaxYValues() -> (min: CGFloat, max: CGFloat) {
        
        if let collectionView = collectionView ,let delegate = collectionView.delegate as? CollectionGraphDelegateLayout {
            
            return delegate.minAndMaxYValuesIn(collectionView)
        }
        return (0, 0)
    }
    
    internal func sizeOfCell(at indexPath: IndexPath) -> CGSize {
        if let collectionView = collectionView ,let delegate = collectionView.delegate as? CollectionGraphDelegateLayout {
            
            return delegate.graphCollectionView(collectionView, sizeForItemAt: indexPath)
        }
        return CGSize.zero
    }
    
    internal func userPoint(at indexPath: IndexPath) -> CGPoint {
        if let collectionView = collectionView ,let dataSource = collectionView.dataSource as? CollectionGraphDataSource {
            
            return dataSource.collectionView(collectionView, pointFor: indexPath)
        }
        return CGPoint.zero
    }
    
    internal func pointInGraph(at indexPath: IndexPath) -> CGPoint {
        
        let userPoint = self.userPoint(at: indexPath)
        
        let size = collectionView?.collectionViewLayout.collectionViewContentSize ?? CGSize.zero
        
        let minXVal = minAndMaxXValues().min
        let maxXVal = minAndMaxXValues().max
        
        let minYVal = minAndMaxYValues().min
        let maxYVal = minAndMaxYValues().max
        
        let percentOnXAxis = Math.percent(ofValue: userPoint.x, fromMin: minXVal, toMax: maxXVal)
        let positionX = Math.lerp(percent: percentOnXAxis, ofDistance: size.width)
        
        let percentOnYAxis = Math.percent(ofValue: userPoint.y, fromMin: minYVal, toMax: maxYVal)
        let positionY = Math.lerp(percent: percentOnYAxis, ofDistance: size.height)
        
        return CGPoint(x: positionX, y: positionY)
    }
    
}
