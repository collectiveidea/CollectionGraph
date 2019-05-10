//
//  CellLayoutAttributes.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 6/12/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import Foundation

internal class CellLayoutAttributesModel {
    
    let decorator: GraphLayoutDecorator
    
    var cache = [IndexPath: UICollectionViewLayoutAttributes]()
    
    required init(decorator: GraphLayoutDecorator) {
        self.decorator = decorator
    }
    
}



extension CellLayoutAttributesModel: LayoutAttributesModel {
    
    /**
     Loops thru all items and creates an index path if it lies within the rect
     */
    internal func indexPathsOfItems(in rect: CGRect) -> [IndexPath] {
        
        var intersectingPaths = [IndexPath]()
        
        for sectionNumber in 0 ..< decorator.numberOfSections {
            for itemNumber in 0 ..< decorator.numberOfItemsIn(section: sectionNumber) {
                
                let indexPathOfItem = IndexPath(item: itemNumber, section: sectionNumber)
                
                let point = decorator.pointInGraph(at: indexPathOfItem)
                
                // Needed so the last point that equals the width of the rect, will be returned.
                // If used on the original rect, the point will not return
                // Example: if rect.width = 100 and the point.x = 100, rect.contains(point) will return false.  However, we want to include that point
                let adjustedRect = CGRect(origin: rect.origin, size: CGSize(width: rect.width + 1, height: rect.height + 1))
                
                if adjustedRect.contains(point) {
                    intersectingPaths += [indexPathOfItem]
                }
            }
        }
        return intersectingPaths
    }
    
    internal func attributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let cachedAttribute = cache[indexPath] {
            return cachedAttribute
        }
        
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let pointInTheGraph = decorator.pointInGraph(at: indexPath)
        
        let sizeOfTheCell = decorator.sizeOfCell(at: indexPath)
        
        attribute.frame = CGRect(
            x: pointInTheGraph.x - sizeOfTheCell.width / 2,
            y: pointInTheGraph.y - sizeOfTheCell.height / 2,
            width: sizeOfTheCell.width,
            height: sizeOfTheCell.height
        )
        
        cache[indexPath] = attribute
        
        return attribute
    }
    
}
