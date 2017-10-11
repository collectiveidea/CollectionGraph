//
//  XAxisLayoutAttributesModel.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/5/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

class XAxisLayoutAttributesModel {
    
    let decorator: GraphLayoutDecorator
    
    var cache = [IndexPath: UICollectionViewLayoutAttributes]()
    
    init(collectionView: GraphCollectionView) {
        
        self.decorator = GraphLayoutDecorator(collectionView: collectionView)
    }
    
}

extension XAxisLayoutAttributesModel: LayoutAttributesModel {
    
    func indexPathsOfItems(in rect: CGRect) -> [IndexPath] {
        var intersectingPaths = [IndexPath]()
        
        let distanceOfXSteps = decorator.distanceOfXSteps()
        
        for itemNumber in 0 ..< decorator.numberOfXSteps() {
            
            let indexPathOfItem = IndexPath(item: itemNumber, section: 0)
            
            let point = CGPoint(x: CGFloat(itemNumber) * distanceOfXSteps, y: 30)
            
            // Needed so the last point that equals the width of the rect, will be returned.
            // If used on the original rect, the point will not return
            // Example: if rect.width = 100 and the point.x = 100, rect.contains(point) will return false.  However, we want to include that point so we add 1 to the size.
            let adjustedRect = CGRect(origin: rect.origin, size: CGSize(width: rect.width + 1, height: rect.height + 1))
            
            if adjustedRect.contains(point) {
                intersectingPaths += [indexPathOfItem]
            }
        }
        
        return intersectingPaths
    }
    
    func attributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let cachedAttribute = cache[indexPath] {
            return cachedAttribute
        }
        
        let attribute = XAxisLayoutAttributes(forSupplementaryViewOfKind: .graphLayoutElementKindXAxisView, with: indexPath)
        
        let contentSize = decorator.contentSize()
        
        let distanceOfXSteps = decorator.distanceOfXSteps()
        
        // TODO: Should be a delegate call incase there are numerous sections with different cell sizes at the first index.  For now we will just grab the first.
        let cellSize = decorator.sizeOfCell(at: IndexPath(item: 0, section: 0))
        
        attribute.frame = CGRect(
            origin: CGPoint(x: CGFloat(indexPath.item) * distanceOfXSteps + cellSize.width / 2 - distanceOfXSteps / 2,
                            y: contentSize.height - decorator.paddingForXAttributes),
            size: CGSize(width: distanceOfXSteps,
                         height: decorator.paddingForXAttributes)
        )
        
        let delta = decorator.minAndMaxXValues()
        let normalizedDelta = delta.max - delta.min

        let percentOnXAxis = Math.percent(ofValue: attribute.frame.origin.x + attribute.frame.size.width / 2, fromMin: 0, toMax: contentSize.width)
        
        let value = Math.lerp(percent: percentOnXAxis, ofDistance: normalizedDelta) + delta.min
        
        attribute.value = value
        
        cache[indexPath] = attribute
        
        return attribute
    }
    
}
