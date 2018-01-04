//
//  LayoutAttributeModel.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 7/26/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import Foundation

protocol LayoutAttributesModel: class {
    
    var decorator: GraphLayoutDecorator { get }
    
    var cache: [IndexPath: UICollectionViewLayoutAttributes] { get set }
    
    func indexPathsOfItems(in rect: CGRect) -> [IndexPath]
    func attributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    
    init(decorator: GraphLayoutDecorator)
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
