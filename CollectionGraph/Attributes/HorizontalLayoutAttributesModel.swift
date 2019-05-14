//
//  HorizontalLayoutAttributesModel.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/11/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import Foundation

class HorizontalLayoutAttributesModel {
    
    let decorator: GraphLayoutDecorator
    
    var cache = [IndexPath: UICollectionViewLayoutAttributes]()
    
    required init(decorator: GraphLayoutDecorator) {
        self.decorator = decorator
    }
    
}

extension HorizontalLayoutAttributesModel: LayoutAttributesModel {
    
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
        
        let contentSize = decorator.contentSize()
        
        let fullHeight = contentSize.height
        
        // TODO: change this to a delegate method like the others
        let cellSize = decorator.sizeOfCell(at: IndexPath(item: 0, section: 0))
        
        let fullHeightForAttributes = fullHeight - decorator.paddingForXAttributes - cellSize.height
        
        let heightForAttributes = fullHeightForAttributes / CGFloat(numberOfSteps)
        
        let frame = CGRect(x: 0, y: heightForAttributes * CGFloat(indexPath.item) + cellSize.height / 2 - heightForAttributes / 2, width: contentSize.width, height: heightForAttributes)
        
        let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: GraphCollectionView.elementKindHorizontalDividers, with: indexPath)
        attribute.frame = frame
        
        attribute.zIndex = -100
        
        return attribute
    }
    
}

