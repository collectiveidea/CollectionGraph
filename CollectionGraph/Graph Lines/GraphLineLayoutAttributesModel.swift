//
//  GraphLineLayoutAttributeModel.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 7/26/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

internal class GraphLineLayoutAttributesModel: LayoutAttributesModel {
    
    let decorator: GraphLayoutDecorator
    
    var cache = [IndexPath : UICollectionViewLayoutAttributes]()
    
    required init(decorator: GraphLayoutDecorator) {
        self.decorator = decorator
    }
    
    internal func indexPathsOfItems(in rect: CGRect) -> [IndexPath] {
        
        var intersectingPaths = [IndexPath]()
        
        for sectionNumber in 0 ..< decorator.numberOfSections {
            
            if decorator.numberOfItemsIn(section: sectionNumber) == 0 {
                return intersectingPaths
            }
            
            for itemNumber in 0 ..< decorator.numberOfItemsIn(section: sectionNumber) - 1 {
                
                let indexPathOfItem = IndexPath(item: itemNumber, section: sectionNumber)
                
                let firstPointInTheGraph = decorator.pointInGraph(at: indexPathOfItem)
                
                // there should always be one more item than the number of lines
                let secondPointInTheGraph = decorator.pointInGraph(at: IndexPath(item: indexPathOfItem.item + 1, section: indexPathOfItem.section))
                
                let pointDeltaX = secondPointInTheGraph.x - firstPointInTheGraph.x
                
                // include some padding to make sure points along the sides of the graph that might be clipped are included
                let adjustedRect = CGRect(origin: CGPoint(x: rect.origin.x - pointDeltaX / 2, y: rect.origin.y), size: CGSize(width: rect.width + pointDeltaX / 2, height: rect.height))
                
                if adjustedRect.contains(firstPointInTheGraph) {
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
        
        if decorator.numberOfItemsIn(section: indexPath.section) > indexPath.item {
            
            let attribute = GraphLineLayoutAttributes(forSupplementaryViewOfKind: .graphLayoutElementKindLine, with: indexPath)
            
            let firstPointInTheGraph = decorator.pointInGraph(at: indexPath)
            
            let secondPointInTheGraph = decorator.pointInGraph(at: IndexPath(item: indexPath.item + 1, section: indexPath.section))
            
            let minX = min(firstPointInTheGraph.x, secondPointInTheGraph.x)
            let minY = min(firstPointInTheGraph.y, secondPointInTheGraph.y)
            
            let maxX = max(firstPointInTheGraph.x, secondPointInTheGraph.x)
            let maxY = max(firstPointInTheGraph.y, secondPointInTheGraph.y)
            
            attribute.frame = CGRect(
                x: minX,
                y: minY,
                width: maxX - minX,
                height: maxY - minY
            )
            
            if firstPointInTheGraph.y <= secondPointInTheGraph.y {
                //line travels from TOP left to BOTTOM right
                attribute.firstPoint = CGPoint(x: minX - minX, y: minY - minY)
                attribute.secondPoint = CGPoint(x: maxX - minX, y: maxY - minY)
            } else {
                //line travels from BOTTOM left to TOP right
                attribute.firstPoint = CGPoint(x: minX - minX, y: maxY - minY)
                attribute.secondPoint = CGPoint(x: maxX - minX, y: minY - minY)
            }
            
            cache[indexPath] = attribute
            
            attribute.zIndex = -50
            
            return attribute
        }
        
        return nil
    }
    
}
