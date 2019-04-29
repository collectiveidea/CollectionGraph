//
//  CollectionGraphProtocols.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 4/26/19.
//  Copyright © 2019 collectiveidea. All rights reserved.
//

import UIKit

@objc public class GraphValue: NSObject {
    public let xValue: CGFloat
    public let yValue: CGFloat
    
    public init(_ xValue: CGFloat, _ yValue: CGFloat) {
        self.xValue = xValue
        self.yValue = yValue
    }
}

@objc public class MinMaxValues: NSObject {
    public let min: CGFloat
    public let max: CGFloat
    
    public init(min: CGFloat, max: CGFloat) {
        self.min = min
        self.max = max
    }
}

@objc public protocol CollectionGraphDataSource: class {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    
    func collectionView(_ collectionView: UICollectionView, valueFor indexPath: IndexPath) -> GraphValue
    
}

@objc public protocol CollectionGraphDelegateLayout: UICollectionViewDelegate {
    
    func graphCollectionView(_ graphCollectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    func minAndMaxYValuesIn(_ graphCollectionView: UICollectionView) -> MinMaxValues//(min: CGFloat, max: CGFloat)
    
    func numberOfYStepsIn(_ graphCollectionView: UICollectionView) -> Int
    
    func minAndMaxXValuesIn(_ graphCollectionView: UICollectionView) -> MinMaxValues//(min: CGFloat, max: CGFloat)
    
    func numberOfXStepsIn(_ graphCollectionView: UICollectionView) -> Int
    
    func distanceBetweenXStepsIn(_ graphCollectionView: UICollectionView) -> CGFloat
    
}

@objc public protocol CollectionGraphXDelegate: class {
    
    func bottomPaddingFor(_ graphCollectionView: UICollectionView) -> CGFloat
    
}

@objc public protocol CollectionGraphYDelegate: class {
    
    func leftSidePaddingFor(_ graphCollectionView: UICollectionView) -> CGFloat
    
}

@objc public protocol CollectionGraphBarGraphDelegate: class {
    
    func widthOfBarFor(_ graphCollectionView: UICollectionView) -> CGFloat
    
}
