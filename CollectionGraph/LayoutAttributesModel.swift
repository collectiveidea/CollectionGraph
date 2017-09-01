//
//  LayoutAttributeModel.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 7/26/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import Foundation

protocol LayoutAttributesModel {
    
    func attributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    func indexPathsOfItems(in rect: CGRect) -> [IndexPath]
    
}

extension LayoutAttributesModel {
    
    internal func attributes(in rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        
        let indexPathsOfItemsInRect = indexPathsOfItems(in: rect)
        
        var attributes = [UICollectionViewLayoutAttributes]()
        
        indexPathsOfItemsInRect.forEach {
            if let attribute = attributesForItem(at: $0) {
                attributes += [attribute]
            }
        }
        
        return attributes
    }
    
}
