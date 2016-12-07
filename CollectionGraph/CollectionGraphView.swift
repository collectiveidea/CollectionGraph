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
    case LineConnectorView = "LineView"
    case BarView = "BarView"
    case YDividerView = "YDivider"
    case YLabelView = "YLabel"
    case XLabelView = "XLabel"
}

@IBDesignable
public class CollectionGraphView: UIView, UICollectionViewDelegate {

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
    
    private var collectionGraphDelegate:CollectionGraphDelegate!
    
    public var visibleIndices: [IndexPath] {
        get {
            return graphCollectionView.indexPathsForVisibleItems
        }
    }
    
    /// A graphCell represents a data point on the graph.
    public var graphCell: UICollectionViewCell? {
        didSet {
            if let graphCell = graphCell {
                self.graphCollectionView.register(graphCell.classForCoder, forCellWithReuseIdentifier: ReuseIDs.GraphCell.rawValue)
            }
        }
    }
    
    /// A barCell represents the bar that sits under a graphCell and extends to the bottom of the graph.  Regular bar graph stuff.
    public var barCell: UICollectionReusableView? {
        didSet {
            if let barCell = barCell {
                self.graphCollectionView.register(barCell.classForCoder, forSupplementaryViewOfKind: ReuseIDs.BarView.rawValue, withReuseIdentifier: ReuseIDs.BarView.rawValue)
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
            layout.graphContentWidth = graphContentWidth
            graphCollectionView.contentOffset.x = -leftInset
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
        didSet{
            layout.ySteps = ySteps
            graphCollectionView.reloadData()
        }
    }
    
    /// The number of labels to display along the x axis.
    @IBInspectable public var xSteps: Int = 3 {
        didSet {
            layout.xSteps = xSteps
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
            graphCollectionView.contentOffset = newValue
        }
    }
    
    /// Scroll the graph to a data point
    public func scrollToDataPoint(graphDatum: GraphDatum, withAnimation animation: Bool, andScrollPosition scrollPosition: UICollectionViewScrollPosition) {
        
        var sectionNumber: Int?
        var itemNumber: Int?
        
        //go thru graphData find matching datum
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
    
    // MARK: - Callbacks
    
    /**
     Callback that returns the visible IndexPaths when scrolling stops
    */
    public func didUpdateVisibleIndices(callback: @escaping (_ indexPaths: Set<IndexPath>, _ sections: Set<Int>) -> ()) {
        collectionGraphDelegate.didUpdateVisibleIndicesCallback = callback
    }
    
    /**
     Callback that returns the graphCell and corresponding GraphDatum.
     
     Use this to set any properties on the graphCell like color, layer properties, or any custom visual properties from your subclass.
    */
    public func setCellProperties(cellCallback: @escaping (_ cell: UICollectionViewCell, _ data: GraphDatum, _ section: Int) -> ()) {
        collectionGraphDataSource.cellCallback = cellCallback
    }

    /// Callback to set the size of the graphCell
    public func setCellSize(layoutCallback: @escaping (_ data: GraphDatum, _ section: Int) -> (CGSize)) {
        layout.cellLayoutCallback = layoutCallback
    }
    
    /**
     Callback that returns the barCell and corresponding GraphDatum.
     
     Use this to set any properties on the barCell like color, layer properties, or any custom visual properties from your subclass.
    */
    public func setBarViewProperties(cellCallback: @escaping (_ cell: UICollectionReusableView, _ data: GraphDatum, _ section: Int) -> ()) {
        if barCell == nil {
            barCell = UICollectionReusableView()
        }
        
        layout.displayBars = true
        collectionGraphDataSource.barCallback = cellCallback
    }
    
    /// Callback to set the width of the barCell
    public func setBarViewWidth(layoutCallback: @escaping (_ data: GraphDatum, _ section: Int) -> (CGFloat)) {
        layout.barLayoutCallback = layoutCallback
    }
    
    /**
     Callback that returns the Connector Lines and corresponding GraphDatum.
     
     Use this to set any properties on the line like color, dot patter, cap, or any custom visual properties from your subclass.
     
     - parameter line: GraphLineShapeLayer is a CAShapeLayer subclass with an extra straightLines Bool you can set.  The default is false.
    */
    public func setLineViewProperties(lineCallback: @escaping (_ line: GraphLineShapeLayer, _ data: GraphDatum, _ section: Int) -> ()) {
        layout.displayLineConnectors = true
        
        self.graphCollectionView.register(LineConnectorView.classForCoder(), forSupplementaryViewOfKind: ReuseIDs.LineConnectorView.rawValue, withReuseIdentifier: ReuseIDs.LineConnectorView.rawValue)
        
        collectionGraphDataSource.lineCallback = lineCallback
    }
    
    /**
     Callback to set the text of label along the x axis
     
     - data: provides the current String and its section number
     
     - Tip: Useful for converting Dates that were converted to Ints back to Dates
    */
    public func setXLabelText(xLabelCallback: @escaping (_ currentString: String, _ section: Int) -> (String)) {
        collectionGraphDataSource.xLabelCallback = xLabelCallback
    }

    // MARK: - View Lifecycle

    // TODO: Remove layout as a parameter
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layout.invalidateLayout()
    }

    func addCollectionView() {
        let xibView = XibLoader.viewFromXib(name: "GraphCollectionView", owner: self)

        xibView?.frame = bounds

        if let xibView = xibView {
            addSubview(xibView)
        }
    }

}
