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
    
    @IBOutlet public weak var collectionGraphDataSource: CollectionGraphDataSource?
    @IBOutlet public weak var collectionGraphDelegateLayout: CollectionGraphDelegateLayout? {
        didSet {
            collectionView.delegate = collectionGraphDelegateLayout
        }
    }
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
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        addSubview(collectionView)
        constrainCollectionView()
        layout.cellLayoutAttributesModel = CellLayoutAttributesModel(decorator: decorator)
    }
    
    func constrainCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // MARK: - UICollectioView modifiers
    
    public func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    public func register(_ nib: UINib?, forCellWithReuseIdentifier id: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: id)
    }
    
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
    public var contentInset: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            collectionView.contentInset = contentInset
        }
    }
    
}

extension CollectionGraph: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionGraphDataSource?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionGraphDataSource!.collectionView(collectionView, cellForItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case .graphLayoutElementKindLine:
            let line = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: .graphLayoutElementKindLine,
                                                                       for: indexPath)
            return line
        case .graphLayoutElementKindXAxisView:
            let xLabel = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: .graphLayoutElementKindXAxisView,
                                                                         for: indexPath) as! LabelReusableView
//            xLabel.backgroundColor = .red
//            xLabel.label.text = textForXLabelAt(indexPath: indexPath, fromValue: xLabel.value)
//
//            xLabel.valueChanged = { [unowned self] value, indexPath in
//                xLabel.label.text = self.textForXLabelAt(indexPath: indexPath, fromValue: value)
//            }

            return xLabel

        case .graphLayoutElementKindYAxisView:
            let yLabel = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: .graphLayoutElementKindYAxisView,
                                                                         for: indexPath) as! LabelReusableView
//            let color = collectionView.backgroundColor?.withAlphaComponent(0.8)
//            yLabel.backgroundColor = color

//            yLabel.label.text = String(format: "%.0f", yLabel.value)
//
//            yLabel.valueChanged = { value, indexPath in
//                yLabel.label.text = String(format: "%.0f", value)
//            }

            return yLabel

        case .graphLayoutElementKindBarGraph:
            return collectionView.dequeueReusableSupplementaryView(ofKind: .graphLayoutElementKindBarGraph, withReuseIdentifier: .graphLayoutElementKindBarGraph, for: indexPath)

        default:
            let horizontalView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                 withReuseIdentifier: .graphLayoutElementKindHorrizontalDividersView,
                                                                                 for: indexPath) as! HorizontalDividerLineReusableView
            horizontalView.line.lineDashPattern = [10, 5]
            return horizontalView
        }
    }
    
}

