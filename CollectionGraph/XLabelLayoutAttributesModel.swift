//
//  XLabelLayoutAttributesModel.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/5/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

class XLabelLayoutAttributesModel {
    let decorator: GraphLayoutDecorator
    
    var cache = [IndexPath: UICollectionViewLayoutAttributes]()
    
    init(collectionView: UICollectionView) {
        
        self.decorator = GraphLayoutDecorator(collectionView: collectionView)
    }
    
    
}

extension XLabelLayoutAttributesModel: LayoutAttributesModel {
    
    func indexPathsOfItems(in rect: CGRect) -> [IndexPath] {
        var intersectingPaths = [IndexPath]()
        
        let distanceOfXSteps = decorator.distanceOfXSteps()
        
        for itemNumber in 0 ..< decorator.numberOfXSteps() {
            
            let indexPathOfItem = IndexPath(item: itemNumber, section: 0)
            
            let point = CGPoint(x: CGFloat(itemNumber) * distanceOfXSteps, y: 30)
            
            // Needed so the last point that equals the width of the rect, will be returned.
            // If used on the original rect, the point will not return
            // Example: if rect.width = 100 and the point.x = 100, rect.contains(point) will return false.  However, we want to include that point
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
        
        let attribute = XLabelLayoutAttributes(forSupplementaryViewOfKind: .graphLayoutElementKindXLabel, with: indexPath)
        
        let distanceOfXSteps = decorator.distanceOfXSteps()
        
        attribute.frame = CGRect(origin: CGPoint(x: CGFloat(indexPath.item) * distanceOfXSteps, y: 30), size: CGSize(width: 10, height: 10))
        
        let delta = decorator.minAndMaxXValues()
        let normalizedDelta = delta.max - delta.min

        let percentOnXAxis = Math.percent(ofValue: attribute.frame.origin.x + attribute.frame.size.width / 2, fromMin: 0, toMax: decorator.contentWidth())
        
        let value = Math.lerp(percent: percentOnXAxis, ofDistance: normalizedDelta) + delta.min
        
        let valueString = decorator.textForXLabelFrom(value) ?? "\(value)"
        
        attribute.text = valueString//Math.lerp(percent: percentOnXAxis, ofDistance: normalizedDelta)
        
        cache[indexPath] = attribute
        
        return attribute
    }
    
}
