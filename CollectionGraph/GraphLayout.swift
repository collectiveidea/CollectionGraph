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
    
    private lazy var cellLayoutAttributes: CellLayoutAttributes = CellLayoutAttributes(graphLayout: self)
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributes = [UICollectionViewLayoutAttributes]()
        
        let indexPathsOfItemsInRect = cellLayoutAttributes.indexPathsOfItems(in: rect)

        indexPathsOfItemsInRect.forEach {
            if let attribute = layoutAttributesForItem(at: $0) {
                attributes += [attribute]
            }
        }
        
        return attributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cellLayoutAttributes.attributesForItem(at: indexPath)
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
