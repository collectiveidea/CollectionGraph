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
    var section: Int { get set }
}

public struct GraphCellLayoutAttribues {
    public var size: CGSize
    public init(size: CGSize) {
        self.size = size
    }
}

extension Sequence where Iterator.Element == GraphDatum {

    func filterBySection(_ section: Int) -> [GraphDatum] {
        return filter { $0.section == section }
    }

    func numberOfSections() -> Int {
        var numbers = Set<Int>()
        forEach { graphData in
            numbers.insert(graphData.section)
        }
        return numbers.count
    }

}

public enum ReuseIDs: String {
    case GraphCell = "GraphCell"
    case LineConnectorView = "LineView"
    case BarView = "BarView"
    case YDividerView = "YDivider"
    case XLabelView = "XLabel"
}

extension ReuseIDs {
    
}

@IBDesignable
public class CollectionGraphView: UIView {

    public var graphData: [GraphDatum]? {
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
        
        self.graphCollectionView.register(LineConnectorView.classForCoder(), forSupplementaryViewOfKind: ReuseIDs.LineConnectorView.rawValue, withReuseIdentifier: ReuseIDs.LineConnectorView.rawValue)
    }
    
    // MARK: - Callbacks
    
    public func setCellProperties(cellCallback: @escaping (_ cell: UICollectionViewCell, _ data: GraphDatum) -> ()) {
        collectionGraphDataSource.cellCallback = cellCallback
    }
    
    public func setCellLayout(layoutCallback: @escaping (_ data: GraphDatum) -> (GraphCellLayoutAttribues)) {
        layout.layoutCallback = layoutCallback
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
