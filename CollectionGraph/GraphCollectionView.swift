//
//  GraphCollectionView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 5/23/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

public protocol CollectionGraphDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, pointFor indexPath: IndexPath) -> CGPoint
    
}

public protocol CollectionGraphDelegateLayout: UICollectionViewDelegate {
    
    func graphCollectionView(_ graphCollectionView: UICollectionView, sizeForItemAt: IndexPath) -> CGSize
    
    func minAndMaxYValuesIn(_ graphCollectionView: UICollectionView) -> (min: CGFloat, max: CGFloat)
        
    func numberOfYStepsIn(_ graphCollectionView: UICollectionView) -> Int
    
    func minAndMaxXValuesIn(_ graphCollectionView: UICollectionView) -> (min: CGFloat, max: CGFloat)
    
    func numberOfXStepsIn(_ graphCollectionView: UICollectionView) -> Int
    
    func distanceBetweenXStepsIn(_ graphCollectionView: UICollectionView) -> CGFloat

}

open class GraphCollectionView: UICollectionView {
    
    override open func awakeFromNib() {
        
        collectionViewLayout = GraphLayout()
        
    }
    
}
