//
//  GraphLayout.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 5/23/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

/*
 on frame change
 loop thru number of items in index,
 request point for index
 see if point is in rect
 if yes
    create attributes
    set attributes
    cache attributes
 if no
    return nil
 
 
 =====
 issue is that every frame change we loop over the data and check if it intersects the rect
 */

import UIKit

internal class GraphLayout: UICollectionViewLayout {
    
    private var numberOfSections: Int {
        get {
            if let collectionView = collectionView ,let dataSource = collectionView.dataSource as? CollectionGraphDataSource {
                return dataSource.numberOfSections?(in: collectionView) ?? 0
            }
            return 0
        }
    }
    
    private func numberOfItemsIn(section: Int) -> Int {
        
        if let collectionView = collectionView ,let dataSource = collectionView.dataSource as? CollectionGraphDataSource {
            
            return dataSource.collectionView(collectionView, numberOfItemsInSection: section)
        }
        return 0
    }
    
    private func minAndMaxXValues() -> (min: CGFloat, max: CGFloat) {
        
        if let collectionView = collectionView ,let delegate = collectionView.delegate as? CollectionGraphDelegateLayout {
            
            return delegate.minAndMaxXValuesIn(collectionView)
        }
        return (0, 0)
    }
    
    private func userPoint(at indexPath: IndexPath) -> CGPoint {
        if let collectionView = collectionView ,let dataSource = collectionView.dataSource as? CollectionGraphDataSource {
            
            return dataSource.collectionView(collectionView, pointFor: indexPath)
        }
        return CGPoint.zero
    }
    
    private func pointInGraph(from userPoint: CGPoint) -> CGPoint {
        let size = collectionViewContentSize
        
        let minXVal = minAndMaxXValues().min
        let maxXVal = minAndMaxXValues().max
        
        let minYVal = minAndMaxXValues().min
        let maxYVal = minAndMaxXValues().max
        
        //..... do maths
        let percentOnXAxis = Math.percent(ofValue: userPoint.x, fromMin: minXVal, toMax: maxXVal)
        let positionX = Math.lerp(percent: percentOnXAxis, ofDistance: size.width)
        
        let percentOnYAxis = Math.percent(ofValue: userPoint.y, fromMin: minYVal, toMax: maxYVal)
        let positionY = Math.lerp(percent: percentOnYAxis, ofDistance: size.height)
        
        return CGPoint(x: positionX, y: positionY)
    }
    
    private func sizeOfCell(at indexPath: IndexPath) -> CGSize {
        if let collectionView = collectionView ,let delegate = collectionView.delegate as? CollectionGraphDelegateLayout {
            
            return delegate.graphCollectionView(collectionView, sizeForItemAt: indexPath)
        }
        return CGSize.zero
    }
    
    private func indexPathsOfItems(in rect: CGRect) -> [IndexPath] {
        
        var intersectingPaths = [IndexPath]()
        
        for sectionNumber in 0 ..< numberOfSections {
            for itemNumber in 0 ..< numberOfItemsIn(section: sectionNumber) {
                
                let indexPathOfItem = IndexPath(item: itemNumber, section: sectionNumber)
                
                let point = userPoint(at: indexPathOfItem)
                
                if rect.contains(point) {
                    intersectingPaths += [indexPathOfItem]
                }
            }
        }
        return intersectingPaths
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributes = [UICollectionViewLayoutAttributes]()
        
        let indexPathsOfItemsInRect = indexPathsOfItems(in: rect)

        indexPathsOfItemsInRect.forEach {
            if let attribute = layoutAttributesForItem(at: $0) {
                attributes += [attribute]
            }
        }
        
        return attributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let usersPoint = userPoint(at: indexPath)
        let pointInTheGraph = pointInGraph(from: usersPoint)
        
        let sizeOfTheCell = sizeOfCell(at: indexPath)
        
        attribute.frame = CGRect(
            x: pointInTheGraph.x - sizeOfTheCell.width / 2,
            y: pointInTheGraph.y - sizeOfTheCell.height / 2,
            width: sizeOfTheCell.width,
            height: sizeOfTheCell.height
        )
        
        return attribute
    }
    
    override var collectionViewContentSize: CGSize {
        
        if let collectionView = collectionView, let delegate = collectionView.delegate as? CollectionGraphDelegateLayout {
            
            let distanceBetweenXSteps = delegate.distanceBetweenXStepsIn(collectionView)
            
            let numberOfXSteps: CGFloat = CGFloat(delegate.numberOfXStepsIn(collectionView))
            
            let widthPadding = collectionView.contentInset.left + collectionView.contentInset.right
            
            let heightOfCollectionView = collectionView.frame.height
            
            let heightPadding = collectionView.contentInset.top + collectionView.contentInset.bottom
            
            let width = distanceBetweenXSteps * numberOfXSteps - widthPadding
            let height = heightOfCollectionView - heightPadding
            
            return CGSize(width: width, height: height)
        }
        return CGSize.zero
    }
    
}
