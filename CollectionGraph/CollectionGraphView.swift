//
//  CollectionGraphView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/23/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

// TODO: - reconsider what GraphdData should be to more easily identify it
public protocol GraphDatum {
    var point: CGPoint { get set }
}

public enum ReuseIDs: String {
    case GraphCell = "GraphCell"
    case LineConnectorView = "LineView"
    case BarView = "BarView"
    case YDividerView = "YDivider"
    case XLabelView = "XLabel"
}

public enum ReuseIDs: String {
    case GraphCell = "GraphCell"
    case LineSupplementaryView = "LineView"
    case BarSupplementaryView = "BarView"
}

@IBDesignable
public class CollectionGraphView: UIView {

    public var graphData: [[GraphDatum]]? {
        didSet {
            if let graphData = graphData {
                layout.graphData = graphData
                collectionGraphDataSource.graphData = graphData
            }
        }
    }

    var collectionGraphDataSource = CollectionGraphDataSource()

    public var graphCell: UICollectionViewCell? {
        didSet {
            if let graphCell = graphCell {
                self.graphCollectionView.register(graphCell.classForCoder, forCellWithReuseIdentifier: ReuseIDs.GraphCell.rawValue)
            }
        }
    }
    
    public var barCell: UICollectionReusableView? {
        didSet {
            if let barCell = barCell {
                self.graphCollectionView.register(barCell.classForCoder, forSupplementaryViewOfKind: ReuseIDs.BarView.rawValue, withReuseIdentifier: ReuseIDs.BarView.rawValue)
            }
        }
    }

    private var layout = GraphLayout()
    
    @IBInspectable var ySteps: Int = 6 {
        didSet{
            layout.ySteps = ySteps
        }
    }
    @IBInspectable var xSteps: Int = 3 {
        didSet {
            layout.xSteps = xSteps
        }
    }

    @IBInspectable public var topInset: CGFloat = 10 {
        didSet {
            graphCollectionView.contentInset.top = topInset
        }
    }
    @IBInspectable public var leftInset: CGFloat = 20 {
        didSet {
            graphCollectionView.contentInset.left = leftInset
        }
    }
    @IBInspectable public var bottomInset: CGFloat = 20 {
        didSet {
            graphCollectionView.contentInset.bottom = bottomInset
        }
    }
    @IBInspectable public var rightInset: CGFloat = 20 {
        didSet {
            graphCollectionView.contentInset.right = rightInset
        }
    }

    @IBOutlet weak var graphCollectionView: UICollectionView! {
        didSet {
            graphCollectionView.dataSource = collectionGraphDataSource
            graphCollectionView.collectionViewLayout = layout

            graphCollectionView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            graphCollectionView.contentOffset.x = -leftInset

            registerDefaultCells()
        }
    }
    
    func registerDefaultCells() {
        self.graphCollectionView.register(YDividerLineView.classForCoder(), forSupplementaryViewOfKind: ReuseIDs.YDividerView.rawValue, withReuseIdentifier: ReuseIDs.YDividerView.rawValue)

        self.graphCollectionView.register(XLabelView.classForCoder(), forSupplementaryViewOfKind: ReuseIDs.XLabelView.rawValue, withReuseIdentifier: ReuseIDs.XLabelView.rawValue)
    }
    
    // MARK: - Callbacks
    
    public func setCellProperties(cellCallback: @escaping (_ cell: UICollectionViewCell, _ data: GraphDatum) -> ()) {
        collectionGraphDataSource.cellCallback = cellCallback
    }
    
    public func setCellSize(layoutCallback: @escaping (_ data: GraphDatum) -> (CGSize)) {
        layout.cellLayoutCallback = layoutCallback
    }
    
    public func setBarViewProperties(cellCallback: @escaping (_ cell: UICollectionReusableView, _ data: GraphDatum) -> ()) {
        if barCell == nil {
            barCell = UICollectionReusableView()
        }
        
        layout.displayBars = true
        collectionGraphDataSource.barCallback = cellCallback
    }
    
    public func setBarViewWidth(layoutCallback: @escaping (_ data: GraphDatum) -> (CGFloat)) {
        layout.barLayoutCallback = layoutCallback
    }
    
    public func setLineViewProperties(lineCallback: @escaping (_ line: GraphLineShapeLayer, _ data: GraphDatum) -> ()) {
        layout.displayLineConnectors = true
        
        self.graphCollectionView.register(LineConnectorView.classForCoder(), forSupplementaryViewOfKind: ReuseIDs.LineConnectorView.rawValue, withReuseIdentifier: ReuseIDs.LineConnectorView.rawValue)
        
        collectionGraphDataSource.lineCallback = lineCallback
    }

    // MARK: - View Lifecycle

    required public init(frame: CGRect, layout: GraphLayout, graphCell: UICollectionViewCell) {
        super.init(frame: frame)

        addCollectionView()

        self.layout = layout
        self.graphCell = graphCell
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addCollectionView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addCollectionView()
        
        defer {
            graphCell = UICollectionViewCell()
        }
    }

    func addCollectionView() {
        let xibView = XibLoader.viewFromXib(name: "GraphCollectionView", owner: self)

        xibView?.frame = bounds

        if let xibView = xibView {
            addSubview(xibView)
        }
    }

}
