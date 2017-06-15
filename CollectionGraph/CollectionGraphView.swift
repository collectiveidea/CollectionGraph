//
//  CollectionGraphView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/23/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

/**
 CollectionGraphView requires its data to conform to GraphDatum.

 You may create a struct that conforms to, but also supplies more information.
 You will be able to access that information during callbacks so you can customize Cells, Bar lines, and Line views.
*/
public protocol GraphDatum {
    var point: CGPoint { get set }
}

public enum ReuseIDs: String {
    case GraphCell = "GraphCell"
    case LineConnectorView = "Line"
    case BarView = "Bar"
    case YDividerView = "YDivider"
    case YLabelView = "YLabel"
    case XLabelView = "XLabel"
    case SideBarView = "SideBar"
}

@IBDesignable
public class CollectionGraphView: UIView, UICollectionViewDelegate {

    public weak var collectionGraphViewDelegate: CollectionGraphViewDelegate? {
        didSet {
            collectionGraphDelegate.collectionGraphViewDelegate = collectionGraphViewDelegate
        }
    }

    public weak var collectionGraphCellDelegate: CollectionGraphCellDelegate? {
        didSet {
            collectionGraphDataSource.collectionGraphCellDelegate = collectionGraphCellDelegate
            layout.collectionGraphCellDelegate = collectionGraphCellDelegate
        }
    }

    public weak var collectionGraphBarDelegate: CollectionGraphBarDelegate? {
        didSet {
            if barView == nil {
                barView = UICollectionReusableView()
            }

            collectionGraphDataSource.collectionGraphBarDelegate = collectionGraphBarDelegate
            layout.collectionGraphBarDelegate = collectionGraphBarDelegate
        }
    }

    public weak var collectionGraphLineDelegate: CollectionGraphLineDelegate? {
        didSet {
            collectionGraphDataSource.collectionGraphLineDelegate = collectionGraphLineDelegate

            layout.displayLineConnectors = true

            self.graphCollectionView.register(
                LineConnectorView.classForCoder(),
                forSupplementaryViewOfKind: ReuseIDs.LineConnectorView.rawValue,
                withReuseIdentifier: ReuseIDs.LineConnectorView.rawValue)
        }
    }

    public weak var collectionGraphLineFillDelegate: CollectionGraphLineFillDelegate? {
        didSet {
            collectionGraphDataSource.collectionGraphLineFillDelegate = collectionGraphLineFillDelegate
        }
    }

    public weak var collectionGraphLabelsDelegate: CollectionGraphLabelsDelegate? {
        didSet {
            collectionGraphDataSource.collectionGraphLabelsDelegate = collectionGraphLabelsDelegate
        }
    }

    public weak var collectionGraphYDividerLineDelegate: CollectionGraphYDividerLineDelegate? {
        didSet {
            collectionGraphDataSource.collectionGraphYDividerLineDelegate = collectionGraphYDividerLineDelegate
        }
    }
    
    /// Each GraphDatum array will define a new section in the graph.
    public var graphData: [[GraphDatum]]? {
        didSet {
            if let graphData = graphData {
                layout.graphData = graphData
                collectionGraphDataSource.graphData = graphData
                graphCollectionView.reloadData()
            }
        }
    }

    private var collectionGraphDataSource = CollectionGraphDataSource()

    private var collectionGraphDelegate: CollectionGraphDelegate!

    /** A graphCell represents a data point on the graph.

     C = graphCell

     | C
     |         C
     |     C
     |             C
     |                 C
     |____________________
     1   2   3   4   5

     */
    public var graphCell: UICollectionViewCell? {
        didSet {
            if let graphCell = graphCell {
                self.graphCollectionView.register(graphCell.classForCoder, forCellWithReuseIdentifier: ReuseIDs.GraphCell.rawValue)
            }
        }
    }

    /**
     Used for a bar graph

     A barView represents the bar that sits under a graphCell and extends to the bottom of the graph.

     In order to display the graph with bars you need to initialize a barCell
    */
    public var barView: UICollectionReusableView? {
        didSet {
            if let barView = barView {
                self.graphCollectionView.register(barView.classForCoder, forSupplementaryViewOfKind: ReuseIDs.BarView.rawValue, withReuseIdentifier: ReuseIDs.BarView.rawValue)
                layout.displayBars = true
            }
        }
    }

    /**
     A view that lies behind the y axis labels and above the plotted graph.  Useful for covering the graph when it scrolls behind the y labels.

     **Note!**
     You need to provide a subclass of UICollectionReusableView and override ````init(frame: CGRect)````.
     Inside the init block is where you set your customizations

     Initializiing a UICollectionReusableView() and then settings its background color will not work.

     **Example**

     ````
     // MySideBarClass.swift
     override init(frame: CGRect) {
         super.init(frame: frame)
         backgroundColor = UIColor.red
     }
     ````
    */
    public var ySideBarView: UICollectionReusableView? {
        didSet {
            if let ySideBarView = ySideBarView {
                layout.ySideBarView = ySideBarView

                graphCollectionView.collectionViewLayout.register(ySideBarView.classForCoder, forDecorationViewOfKind: ReuseIDs.SideBarView.rawValue)
            }
        }
    }

    private var layout = GraphLayout()

    /**
    The width of the scrollable graph content.

    - Default is is the width of the CollectionGraphView.
    - All data points will plot to fit within specified width.
    */
    @IBInspectable public var graphContentWidth: CGFloat = 0 {
        didSet {
            self.layout.graphContentWidth = self.graphContentWidth
            self.graphCollectionView.contentOffset.x = -self.leftInset
        }
    }

    /// The color of the labels on the x and y axes.
    @IBInspectable public var textColor: UIColor = UIColor.darkText {
        didSet {
            collectionGraphDataSource.textColor = textColor
            graphCollectionView.reloadData()
        }
    }

    @IBInspectable public var textSize: CGFloat = 8 {
        didSet {
            collectionGraphDataSource.textSize = textSize
        }
    }

    public var fontName: String? {
        didSet {
            collectionGraphDataSource.fontName = fontName
        }
    }

    /// The color of the horizontal lines that run across the graph.
    @IBInspectable public var yDividerLineColor: UIColor = UIColor.lightGray {
        didSet {
            collectionGraphDataSource.yDividerLineColor = yDividerLineColor
            graphCollectionView.reloadData()
        }
    }

    /// The number of horizonal lines and labels to display on the graph along the y axis
    @IBInspectable public var ySteps: Int = 6 {
        didSet {
            layout.ySteps = ySteps
            collectionGraphDataSource.ySteps = ySteps
            graphCollectionView.reloadData()
        }
    }

    /// The number of labels to display along the x axis.
    @IBInspectable public var xSteps: Int = 3 {
        didSet {
            layout.xSteps = xSteps
            collectionGraphDataSource.xSteps = xSteps
            graphCollectionView.reloadData()
        }
    }

    /// Distance offset from the top of the view
    @IBInspectable public var topInset: CGFloat = 10 {
        didSet {
            graphCollectionView.contentInset.top = topInset
            graphCollectionView.reloadData()
        }
    }

    /**
    Distance offset from the left side of the view.

    This makes space for the y labels.
    */
    @IBInspectable public var leftInset: CGFloat = 20 {
        didSet {
            graphCollectionView.contentInset.left = leftInset
            graphCollectionView.reloadData()
        }
    }

    /**
     Distance offset from the bottom of the view.

     This makes space for the x labels.
     */
    @IBInspectable public var bottomInset: CGFloat = 20 {
        didSet {
            graphCollectionView.contentInset.bottom = bottomInset
            graphCollectionView.reloadData()
        }
    }

    /// Distance offset from the right of the view
    @IBInspectable public var rightInset: CGFloat = 20 {
        didSet {
            graphCollectionView.contentInset.right = rightInset
            graphCollectionView.reloadData()
        }
    }

    @IBOutlet internal weak var graphCollectionView: UICollectionView! {
        didSet {
            graphCollectionView.dataSource = collectionGraphDataSource

            collectionGraphDelegate = CollectionGraphDelegate(graphCollectionView)
            graphCollectionView.delegate = collectionGraphDelegate

            graphCollectionView.collectionViewLayout = layout

            graphCollectionView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            graphCollectionView.contentOffset.x = -leftInset

            registerDefaultCells()
        }
    }

    private func registerDefaultCells() {
        self.graphCollectionView.register(YDividerLineView.classForCoder(), forSupplementaryViewOfKind: ReuseIDs.YDividerView.rawValue, withReuseIdentifier: ReuseIDs.YDividerView.rawValue)

        self.graphCollectionView.register(LabelView.classForCoder(), forSupplementaryViewOfKind: ReuseIDs.XLabelView.rawValue, withReuseIdentifier: ReuseIDs.XLabelView.rawValue)

        self.graphCollectionView.register(LabelView.classForCoder(), forSupplementaryViewOfKind: ReuseIDs.YLabelView.rawValue, withReuseIdentifier: ReuseIDs.YLabelView.rawValue)
    }

    public var contentOffset: CGPoint {
        get {
            return graphCollectionView.contentOffset
        }
        set {
            self.graphCollectionView.contentOffset = newValue
            self.graphCollectionView.layoutIfNeeded()
            self.graphCollectionView.collectionViewLayout.invalidateLayout()
        }
    }

    /// Scroll the graph to a data point
    public func scrollToDataPoint(graphDatum: GraphDatum, withAnimation animation: Bool, andScrollPosition scrollPosition: UICollectionViewScrollPosition) {

        var sectionNumber: Int?
        var itemNumber: Int?

        // go thru graphData find matching datum
        if let graphData = graphData {
            for section in 0 ... graphData.count - 1 {

                itemNumber = graphData[section].index(where: { (data) -> Bool in
                    sectionNumber = section
                    return data.point == graphDatum.point
                })
            }
        }

        if let sectionNumber = sectionNumber, let itemNumber = itemNumber {
            let indexPath = IndexPath(item: itemNumber, section: sectionNumber)
            graphCollectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animation)
        }
    }

    // MARK: - View Lifecycle

    required public init(frame: CGRect, graphCell: UICollectionViewCell) {
        super.init(frame: frame)

        addCollectionView()

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
