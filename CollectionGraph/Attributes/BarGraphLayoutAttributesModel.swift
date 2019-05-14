//
//  BarGraphLayoutAttributesModel.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 11/28/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

class BarGraphLayoutAttributesModel {
    
    let decorator: GraphLayoutDecorator
    
    var cache = [IndexPath: UICollectionViewLayoutAttributes]()
    
    required init(decorator: GraphLayoutDecorator) {
        self.decorator = decorator
    }
    
}

extension BarGraphLayoutAttributesModel: LayoutAttributesModel {
    
    func indexPathsOfItems(in rect: CGRect) -> [IndexPath] {
        
        var intersectingPaths = [IndexPath]()
        
        for sectionNumber in 0 ..< decorator.numberOfSections {
            for itemNumber in 0 ..< decorator.numberOfItemsIn(section: sectionNumber) {
                
                let indexPathOfItem = IndexPath(item: itemNumber, section: sectionNumber)
                
                let point = decorator.pointInGraph(at: indexPathOfItem)
                
                let barWidth = decorator.widthOfBar(at: indexPathOfItem)
                
                let tempBarRect = CGRect(x: point.x - barWidth / 2, y: 0, width: barWidth, height: 20)
                
                if rect.contains(tempBarRect) {
                    intersectingPaths += [indexPathOfItem]
                }
            }
        }
        
        return intersectingPaths
    }
    
    func attributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let cachedAttribute = cache[indexPath] {
            return cachedAttribute
        }
        
        let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: GraphCollectionView.elementKindBarGraph, with: indexPath)
        
        let point = decorator.pointInGraph(at: indexPath)
        
        let barWidth = decorator.widthOfBar(at: indexPath)
        
        let bottomPadding = decorator.paddingForXAttributes
        
        let collectionHeight = decorator.contentSize().height
        
        let barRect = CGRect(x: point.x - barWidth / 2, y: point.y, width: barWidth, height: collectionHeight - point.y - bottomPadding)
        
        attribute.frame = barRect
        
        attribute.zIndex = -100
        
        return attribute
    }
    
}
