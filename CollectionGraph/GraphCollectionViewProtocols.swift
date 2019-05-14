//
//  CollectionGraphProtocols.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 4/26/19.
//  Copyright © 2019 collectiveidea. All rights reserved.
//

import Foundation

public protocol GraphCollectionViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: GraphCollectionView, valueFor indexPath: IndexPath) -> (xValue: CGFloat, yValue: CGFloat)
    
}

public protocol GraphCollectionViewDelegateLayout: UICollectionViewDelegate {
    
    func graphCollectionView(_ graphCollectionView: GraphCollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    func minAndMaxYValuesIn(_ graphCollectionView: GraphCollectionView) -> (min: CGFloat, max: CGFloat)
    
    func numberOfYStepsIn(_ graphCollectionView: GraphCollectionView) -> Int
    
    func minAndMaxXValuesIn(_ graphCollectionView: GraphCollectionView) -> (min: CGFloat, max: CGFloat)
    
    func numberOfXStepsIn(_ graphCollectionView: GraphCollectionView) -> Int
    
    func distanceBetweenXStepsIn(_ graphCollectionView: GraphCollectionView) -> CGFloat
    
}

@objc public protocol GraphCollectionViewXDelegate: class {
    
    func bottomPaddingFor(_ graphCollectionView: GraphCollectionView) -> CGFloat
    
}

@objc public protocol GraphCollectionViewYDelegate: class {
    
    func leftSidePaddingFor(_ graphCollectionView: GraphCollectionView) -> CGFloat
    
}

@objc public protocol GraphCollectionViewBarGraphDelegate: class {
    
    func widthOfBarFor(_ graphCollectionView: GraphCollectionView) -> CGFloat
    
}
