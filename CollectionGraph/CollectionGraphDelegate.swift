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
    
    internal var didEndDeceleratingCallback: ((_ indexPaths: [IndexPath]) -> ())?
    
    public init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndDeceleratingCallback?(collectionView.indexPathsForVisibleItems)
    }
    
    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didEndDeceleratingCallback?(collectionView.indexPathsForVisibleItems)
    }
    
    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDeceleratingCallback?(collectionView.indexPathsForVisibleItems)
    }
    
}
