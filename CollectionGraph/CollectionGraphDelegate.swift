//
//  CollectionGraphDelegate.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 11/21/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class CollectionGraphDelegate: NSObject, UICollectionViewDelegate {
    
    let collectionView: UICollectionView
    
    var visibleIndices = Set<IndexPath>() {
        didSet {
            let sections = visibleIndices.map {
                $0.section
            }
            
            let sectionSet = Set<Int>(sections)
            
            didUpdateVisibleIndicesCallback?(visibleIndices, sectionSet)
        }
    }
    
    internal var didUpdateVisibleIndicesCallback: ((_ indexPaths: Set<IndexPath>, _ sections: Set<Int>) -> ())?
    
    public init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        visibleIndices.insert(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        visibleIndices.remove(indexPath)
    }
    
}
