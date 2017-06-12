//
//  CellLayoutAttributes.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 6/12/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import Foundation

internal class CellLayoutAttributes {
    
    let graphLayout: GraphLayout
    
    let decorator: GraphLayoutDecorator
    
    init(graphLayout: GraphLayout) {
        self.graphLayout = graphLayout
        
        self.decorator = GraphLayoutDecorator(graphLayout: graphLayout)
    }
    
    /**
     Loops thru all items and creates an index path if it lies within the rect
     */
    internal func indexPathsOfItems(in rect: CGRect) -> [IndexPath] {
        
        var intersectingPaths = [IndexPath]()
        
        for sectionNumber in 0 ..< decorator.numberOfSections {
            for itemNumber in 0 ..< decorator.numberOfItemsIn(section: sectionNumber) {
                
                let indexPathOfItem = IndexPath(item: itemNumber, section: sectionNumber)
                
                let point = decorator.pointInGraph(at: indexPathOfItem)
                
                if rect.contains(point) {
                    intersectingPaths += [indexPathOfItem]
                }
            }
        }
        return intersectingPaths
    }
    
    internal func attributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let pointInTheGraph = decorator.pointInGraph(at: indexPath)
        
        let sizeOfTheCell = decorator.sizeOfCell(at: indexPath)
        
        attribute.frame = CGRect(
            x: pointInTheGraph.x - sizeOfTheCell.width / 2,
            y: pointInTheGraph.y - sizeOfTheCell.height / 2,
            width: sizeOfTheCell.width,
            height: sizeOfTheCell.height
        )
        
        return attribute
    }
    
}
