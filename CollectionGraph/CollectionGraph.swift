//
//  CollectionGraph.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 5/23/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

open class CollectionGraph: UIView {
    
    lazy var decorator: GraphLayoutDecorator = GraphLayoutDecorator(collectionGraph: self)
    lazy var layout: GraphLayout = GraphLayout(decorator: decorator)
    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
    
    @IBOutlet public weak var xDelegate: CollectionGraphXDelegate?
    @IBOutlet public weak var yDelegate: CollectionGraphYDelegate?
    @IBOutlet public weak var barGraphDelegate: CollectionGraphBarGraphDelegate?
    
    public var usesWholeNumbersOnYAxis = false
    
    public var isBarGraph = false {
        didSet {
            guard let graphLayout = collectionView.collectionViewLayout as? GraphLayout else { return }
            collectionView.register(BarGraphReusableView.self, forSupplementaryViewOfKind: .graphLayoutElementKindBarGraph, withReuseIdentifier: .graphLayoutElementKindBarGraph)
            graphLayout.barGraphLayoutAttributesModel = BarGraphLayoutAttributesModel(decorator: decorator)
        }
    }
    public var isLineGraph = false {
        didSet {
            guard let graphLayout = collectionView.collectionViewLayout as? GraphLayout else { return }
            collectionView.register(GraphLineReusableView.self, forSupplementaryViewOfKind: .graphLayoutElementKindLine, withReuseIdentifier: .graphLayoutElementKindLine)
            graphLayout.graphLineLayoutAttributesModel = GraphLineLayoutAttributesModel(decorator: decorator)
        }
    }
    public var hasHorizontalGraphLines = false {
        didSet {
            guard let graphLayout = collectionView.collectionViewLayout as? GraphLayout else { return }
            collectionView.register(HorizontalDividerLineReusableView.self, forSupplementaryViewOfKind: .graphLayoutElementKindHorrizontalDividersView, withReuseIdentifier: .graphLayoutElementKindHorrizontalDividersView)
            graphLayout.horizontalLayoutAttributesModel = HorizontalLayoutAttributesModel(decorator: decorator)
        }
    }
    public var hasYAxisLabels = false {
        didSet {
            guard let graphLayout = collectionView.collectionViewLayout as? GraphLayout else { return }
            isUsingYAxisView = true
            collectionView.register(LabelReusableView.self, forSupplementaryViewOfKind: .graphLayoutElementKindYAxisView, withReuseIdentifier: .graphLayoutElementKindYAxisView)
            graphLayout.yAxisLayoutAttributesModel = YAxisLayoutAttributesModel(decorator: decorator)
        }
    }
    public var hasXAxisLabels = false {
        didSet {
            guard let graphLayout = collectionView.collectionViewLayout as? GraphLayout else { return }
            isUsingXAxisView = true
            collectionView.register(LabelReusableView.self, forSupplementaryViewOfKind: .graphLayoutElementKindXAxisView, withReuseIdentifier: .graphLayoutElementKindXAxisView)
            graphLayout.xAxisLayoutAttributesModel = XAxisLayoutAttributesModel(decorator: decorator)
        }
    }
    
    internal var isUsingXAxisView = false
    internal var isUsingYAxisView = false
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout.cellLayoutAttributesModel = CellLayoutAttributesModel(decorator: decorator)
    }
    
//    override open func awakeFromNib() {
//        setupLayout()
//    }
//
//    func setupLayout() {
//        if !(collectionViewLayout is GraphLayout) {
//            collectionViewLayout = GraphLayout()
//        }
//
//        let layout = collectionViewLayout as! GraphLayout
//        let decorator = GraphLayoutDecorator(collectionView: self)
//        layout.cellLayoutAttributesModel = CellLayoutAttributesModel(decorator: decorator)
//    }
    
}

