//
//  CollectionGraphView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/23/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

public protocol GraphData {
    // TODO: - Rethink how to link points to data and define a way for the end user
    // Does it make sense to drop it in a Dictionary with an ID?
    //  What if the user only cares about the actual points?  Is the Dictionary unnecessary and its purpose confusing?
    var point: CGPoint { get set }
    var section: Int { get set }
}

extension Sequence where Iterator.Element == GraphData {

    func filterBySection(_ section: Int) -> [GraphData] {
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

public protocol GraphCellUpdatable: class {
    func update(data: GraphData?)
}

public enum ReuseIDs: String {
    case GraphCell = "GraphCell"
    case LineSupplementaryView = "LineView"
    case BarSupplementaryView = "BarView"
    case YDividerSupplementaryView = "YDivider"
    case XLabelView = "XLabel"
}

public protocol GraphCellDelegate: class {
    func update(data: GraphData?)
    
    var cell: UICollectionViewCell { get }
}

@IBDesignable
public class CollectionGraphView: UIView {

    public weak var delegate: GraphCellDelegate? {
        didSet {
            collectionGraphDataSource.delegate = delegate
            self.graphCollectionView.register(delegate?.cell.classForCoder, forCellWithReuseIdentifier: ReuseIDs.GraphCell.rawValue)
        }
    }

    public var graphData: [GraphData]? {
        didSet {
            if let graphData = graphData, let layout = layout {
                layout.graphData = graphData
                collectionGraphDataSource.graphData = graphData
            }
        }
    }

    var collectionGraphDataSource = CollectionGraphDataSource()

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
