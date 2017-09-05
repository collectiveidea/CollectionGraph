//
//  GraphCollectionView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 5/23/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

public protocol CollectionGraphDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, valueFor indexPath: IndexPath) -> (xValue: CGFloat, yValue: CGFloat)
    
}

public protocol CollectionGraphDelegateLayout: UICollectionViewDelegate {
    
    func graphCollectionView(_ graphCollectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    func minAndMaxYValuesIn(_ graphCollectionView: UICollectionView) -> (min: CGFloat, max: CGFloat)
        
    func numberOfYStepsIn(_ graphCollectionView: UICollectionView) -> Int
    
    func minAndMaxXValuesIn(_ graphCollectionView: UICollectionView) -> (min: CGFloat, max: CGFloat)
    
    func numberOfXStepsIn(_ graphCollectionView: UICollectionView) -> Int
    
    func distanceBetweenXStepsIn(_ graphCollectionView: UICollectionView) -> CGFloat

}

@objc public protocol CollectionGraphXLabelDelegate: class {
    
    func collectionView(_ graphCollectionView: UICollectionView, TextFromValue value: CGFloat) -> String
    
}

open class GraphCollectionView: UICollectionView {
    
    @IBOutlet public weak var xLabelDelegate: CollectionGraphXLabelDelegate?
    
    private let graphLayout = GraphLayout()

    override open func awakeFromNib() {
        graphLayout.cellLayoutAttributesModel = CellLayoutAttributesModel(collectionView: self)
        
        collectionViewLayout = graphLayout
    }
    
    open override func register(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String) {
        
        super.register(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        
        if elementKind == .graphLayoutElementKindLine {
            graphLayout.graphLineLayoutAttributesModel = GraphLineLayoutAttributesModel(collectionView: self)
        } else if elementKind == .graphLayoutElementKindXLabel {
            graphLayout.xLabelLayoutAttributesModel = XLabelLayoutAttributesModel(collectionView: self)
        }
    }
    
}

