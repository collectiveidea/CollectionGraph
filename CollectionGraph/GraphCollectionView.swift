//
//  GraphCollectionView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 5/23/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

public protocol CollectionGraphDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: GraphCollectionView, valueFor indexPath: IndexPath) -> (xValue: CGFloat, yValue: CGFloat)
    
}

public protocol CollectionGraphDelegateLayout: UICollectionViewDelegate {
    
    func graphCollectionView(_ graphCollectionView: GraphCollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    func minAndMaxYValuesIn(_ graphCollectionView: GraphCollectionView) -> (min: CGFloat, max: CGFloat)
        
    func numberOfYStepsIn(_ graphCollectionView: GraphCollectionView) -> Int
    
    func minAndMaxXValuesIn(_ graphCollectionView: GraphCollectionView) -> (min: CGFloat, max: CGFloat)
    
    func numberOfXStepsIn(_ graphCollectionView: GraphCollectionView) -> Int
    
    func distanceBetweenXStepsIn(_ graphCollectionView: GraphCollectionView) -> CGFloat

}

@objc public protocol CollectionGraphXDelegate: class {
    
    func bottomPaddingFor(_ graphCollectionView: GraphCollectionView) -> CGFloat
    
}

@objc public protocol CollectionGraphYDelegate: class {
    
    func leftSidePaddingFor(_ graphCollectionView: GraphCollectionView) -> CGFloat
    
}

open class GraphCollectionView: UICollectionView {
    
    @IBOutlet public weak var xDelegate: CollectionGraphXDelegate?
    @IBOutlet public weak var yDelegate: CollectionGraphYDelegate?
    
    override open func awakeFromNib() {
        setupLayout()
    }
    
    func setupLayout() {
        if !(collectionViewLayout is GraphLayout) {
            collectionViewLayout = GraphLayout()
        }
        
        let layout = collectionViewLayout as! GraphLayout
        layout.cellLayoutAttributesModel = CellLayoutAttributesModel(collectionView: self)
    }
    
    open override func register(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String) {
        
        super.register(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        
        guard let graphLayout = collectionViewLayout as? GraphLayout else {
            return
        }
        
        if elementKind == .graphLayoutElementKindLine {
            graphLayout.graphLineLayoutAttributesModel = GraphLineLayoutAttributesModel(collectionView: self)
        } else if elementKind == .graphLayoutElementKindXAxisView {
            graphLayout.xAxisLayoutAttributesModel = XAxisLayoutAttributesModel(collectionView: self)
        } else if elementKind == .graphLayoutElementKindYAxisView {
            graphLayout.yAxisLayoutAttributesModel = YAxisLayoutAttributesModel(collectionView: self)
        }
    }
    
}

