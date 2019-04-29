//
//  YAxisLayoutAttributesModel.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/11/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import Foundation

class YAxisLayoutAttributesModel {
    
    let decorator: GraphLayoutDecorator
    
    var cache = [IndexPath: UICollectionViewLayoutAttributes]()
    
    required init(decorator: GraphLayoutDecorator) {
        self.decorator = decorator
    }
    
}

extension YAxisLayoutAttributesModel: LayoutAttributesModel {
    
    func indexPathsOfItems(in rect: CGRect) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        let numberOfItems = decorator.numberOfYSteps() + 1
        
        for number in 0..<numberOfItems {
            let indexPath = IndexPath(item: number, section: 0)
            indexPaths += [indexPath]
        }
        
        return indexPaths
    }
    
    func attributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let numberOfSteps = decorator.numberOfYSteps()
        
        let fullHeight = decorator.contentSize().height
        
        // TODO: change this to a delegate method like the others
        let cellSize = decorator.sizeOfCell(at: IndexPath(item: 0, section: 0))
        
        let fullHeightForAttributes = fullHeight - decorator.paddingForXAttributes - cellSize.height
        
        let heightForAttributes = fullHeightForAttributes / CGFloat(numberOfSteps)
        
        let leftInset = decorator.collectionViewContentInsets.left
        
        let frame = CGRect(x: decorator.collectionGraph.collectionView.contentOffset.x, y: heightForAttributes * CGFloat(indexPath.item) + cellSize.height / 2 - heightForAttributes / 2, width: decorator.paddingForYAttributes + leftInset, height: heightForAttributes)
        
        let attribute = AxisLayoutAttributes(forSupplementaryViewOfKind: .graphLayoutElementKindYAxisView, with: indexPath)
        attribute.frame = frame
        
        // Figure Out value
        let delta = decorator.minAndMaxYValues()
        let normalizedDelta = delta.max - delta.min
        
        let percentOnYAxis = Math.percent(ofValue: attribute.frame.origin.y + attribute.frame.size.height / 2 - cellSize.height / 2, fromMin: 0, toMax: fullHeightForAttributes)
        
        var value = normalizedDelta - Math.lerp(percent: percentOnYAxis, ofDistance: normalizedDelta) + delta.min
        
        if decorator.collectionGraph.usesWholeNumbersOnYAxis {
            value = value.rounded()
        }
        
        attribute.value = value
        
        attribute.zIndex = 100
                
        return attribute
    }
    
}
