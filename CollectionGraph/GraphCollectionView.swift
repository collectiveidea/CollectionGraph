//
//  GraphCollectionView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 5/23/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

open class GraphCollectionView: UICollectionView {
    
    lazy var decorator: GraphLayoutDecorator = GraphLayoutDecorator(collectionView: self)
    
    @IBOutlet public weak var xDelegate: CollectionGraphXDelegate?
    @IBOutlet public weak var yDelegate: CollectionGraphYDelegate?
    @IBOutlet public weak var barGraphDelegate: CollectionGraphBarGraphDelegate?
    
    public var usesWholeNumbersOnYAxis = false
    public var isBarGraph = false {
        didSet {
            guard let graphLayout = self.collectionViewLayout as? GraphLayout else { return }
            register(BarGraphReusableView.self, forSupplementaryViewOfKind: .graphLayoutElementKindBarGraph, withReuseIdentifier: .graphLayoutElementKindBarGraph)
            graphLayout.barGraphLayoutAttributesModel = BarGraphLayoutAttributesModel(decorator: decorator)
        }
    }
    public var isLineGraph = false {
        didSet {
            guard let graphLayout = self.collectionViewLayout as? GraphLayout else { return }
            register(GraphLineReusableView.self, forSupplementaryViewOfKind: .graphLayoutElementKindLine, withReuseIdentifier: .graphLayoutElementKindLine)
            graphLayout.graphLineLayoutAttributesModel = GraphLineLayoutAttributesModel(decorator: decorator)
        }
    }
    public var hasHorizontalGraphLines = false {
        didSet {
            guard let graphLayout = self.collectionViewLayout as? GraphLayout else { return }
            register(HorizontalDividerLineReusableView.self, forSupplementaryViewOfKind: .graphLayoutElementKindHorrizontalDividersView, withReuseIdentifier: .graphLayoutElementKindHorrizontalDividersView)
            graphLayout.horizontalLayoutAttributesModel = HorizontalLayoutAttributesModel(decorator: decorator)
        }
    }
    public var hasYAxisLabels = false {
        didSet {
            guard let graphLayout = self.collectionViewLayout as? GraphLayout else { return }
            isUsingYAxisView = true
            register(LabelReusableView.self, forSupplementaryViewOfKind: .graphLayoutElementKindYAxisView, withReuseIdentifier: .graphLayoutElementKindYAxisView)
            graphLayout.yAxisLayoutAttributesModel = YAxisLayoutAttributesModel(decorator: decorator)
        }
    }
    public var hasXAxisLabels = false {
        didSet {
            guard let graphLayout = self.collectionViewLayout as? GraphLayout else { return }
            isUsingXAxisView = true
            register(LabelReusableView.self, forSupplementaryViewOfKind: .graphLayoutElementKindXAxisView, withReuseIdentifier: .graphLayoutElementKindXAxisView)
            graphLayout.xAxisLayoutAttributesModel = XAxisLayoutAttributesModel(decorator: decorator)
        }
    }
    
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
    
}

