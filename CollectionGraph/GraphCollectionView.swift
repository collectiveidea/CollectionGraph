//
//  GraphCollectionView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 5/23/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

open class GraphCollectionView: UICollectionView {
    
    @IBOutlet public weak var xDelegate: CollectionGraphXDelegate?
    @IBOutlet public weak var yDelegate: CollectionGraphYDelegate?
    @IBOutlet public weak var barGraphDelegate: CollectionGraphBarGraphDelegate?
    
    public var usesWholeNumbersOnYAxis: Bool = false
    
    internal var isUsingXAxisView = false
    internal var isUsingYAxisView = false
    
    override open func awakeFromNib() {
        setupLayout()
    }
    
    func setupLayout() {
        if !(collectionViewLayout is GraphLayout) {
            collectionViewLayout = GraphLayout()
        }
        
        let layout = collectionViewLayout as! GraphLayout
        let decorator = GraphLayoutDecorator(collectionView: self)
        layout.cellLayoutAttributesModel = CellLayoutAttributesModel(decorator: decorator)
    }
    
    open override func register(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String) {
        
        super.register(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        
        guard let graphLayout = collectionViewLayout as? GraphLayout else {
            return
        }
        
        let decorator = GraphLayoutDecorator(collectionView: self)
        
        if elementKind == .graphLayoutElementKindLine {
            graphLayout.graphLineLayoutAttributesModel = GraphLineLayoutAttributesModel(decorator: decorator)
        } else if elementKind == .graphLayoutElementKindXAxisView {
            isUsingXAxisView = true
            graphLayout.xAxisLayoutAttributesModel = XAxisLayoutAttributesModel(decorator: decorator)
        } else if elementKind == .graphLayoutElementKindYAxisView {
            isUsingYAxisView = true
            graphLayout.yAxisLayoutAttributesModel = YAxisLayoutAttributesModel(decorator: decorator)
        } else if elementKind == .graphLayoutElementKindHorrizontalDividersView {
            graphLayout.horizontalLayoutAttributesModel = HorizontalLayoutAttributesModel(decorator: decorator)
        } else if elementKind == .graphLayoutElementKindBarGraph {
            graphLayout.barGraphLayoutAttributesModel = BarGraphLayoutAttributesModel(decorator: decorator)
        }
    }
    
}

