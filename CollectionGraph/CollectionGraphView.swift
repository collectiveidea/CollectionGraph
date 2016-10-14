//
//  CollectionGraphView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/23/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

public protocol GraphData {
    var values: [[CGPoint]] { get set }
}

public enum ReuseIDs: String {
    case GraphCell = "GraphCell"
    case LineSupplementaryView = "LineView"
    case BarSupplementaryView = "BarView"
    case YDividerSupplementaryView = "YDivider"
    case XLabelView = "XLabel"
}

@IBDesignable
public class CollectionGraphView: UIView {

    public var graphData: GraphData? {
        didSet {
            if let graphData = graphData, let layout = layout {
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

    @IBInspectable public var layout: GraphLayout? {
        didSet {
            if let layout = layout {
                // place in layout and loop to create
                self.graphCollectionView.collectionViewLayout = layout

                self.graphCollectionView.register(YDividerLineView.classForCoder(), forSupplementaryViewOfKind: ReuseIDs.YDividerSupplementaryView.rawValue, withReuseIdentifier: ReuseIDs.YDividerSupplementaryView.rawValue)

                self.graphCollectionView.register(LineConnectorView.classForCoder(), forSupplementaryViewOfKind: ReuseIDs.LineSupplementaryView.rawValue, withReuseIdentifier: ReuseIDs.LineSupplementaryView.rawValue)

                self.graphCollectionView.register(XLabelView.classForCoder(), forSupplementaryViewOfKind: ReuseIDs.XLabelView.rawValue, withReuseIdentifier: ReuseIDs.XLabelView.rawValue)
            }
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
    @IBInspectable public var bottomInset: CGFloat = 10 {
        didSet {
            graphCollectionView.contentInset.bottom = bottomInset
        }
    }
    @IBInspectable public var rightInset: CGFloat = 10 {
        didSet {
            graphCollectionView.contentInset.right = rightInset
        }
    }

    @IBOutlet weak var graphCollectionView: UICollectionView! {
        didSet {
            graphCollectionView.dataSource = collectionGraphDataSource
            graphCollectionView.backgroundColor = backgroundColor
            graphCollectionView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            graphCollectionView.contentOffset.x = -leftInset
        }
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
    }

    func addCollectionView() {
        let xibView = XibLoader.viewFromXib(name: "GraphCollectionView", owner: self)

        xibView?.frame = bounds

        if let xibView = xibView {
            addSubview(xibView)
        }
    }

}
