//
//  GraphLayout.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

public class GraphLayout: UICollectionViewLayout, RangeFinder {

    internal weak var collectionGraphCellDelegate: CollectionGraphCellDelegate?
    internal weak var collectionGraphBarDelegate: CollectionGraphBarDelegate?

    internal var graphData: [[GraphDatum]]?

    internal var displayBars = false
    internal var displayLineConnectors = false

    internal var ySideBarView: UICollectionReusableView?

    internal var ySteps: Int = 6
    internal var xSteps: Int = 3

    internal var graphContentWidth: CGFloat? // width of graph in points

    internal var cellSize: CGSize = CGSize(width: 3.0, height: 3.0)

    private var backgroundQueueCount = 0

    private var yIncrements: CGFloat {
        get {
            if let graphData = graphData {
                return yDataRange(graphData: graphData, numberOfSteps: ySteps).max / CGFloat(ySteps)
            }
            return 0
        }
    }

    private let labelsZIndex = Int.max
    private let sideBarZIndex = Int.max - 1

    private lazy var spinnerContainer: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        if let collectionViewParent = self.collectionView?.superview {

            container.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            container.layer.cornerRadius = 3

            container.alpha = 0

            collectionViewParent.addSubview(container)

            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)

            container.addSubview(spinner)

            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true

            container.translatesAutoresizingMaskIntoConstraints = false
            container.centerXAnchor.constraint(equalTo: collectionViewParent.centerXAnchor).isActive = true
            container.centerYAnchor.constraint(equalTo: collectionViewParent.centerYAnchor).isActive = true
            container.widthAnchor.constraint(equalToConstant: 35).isActive = true
            container.heightAnchor.constraint(equalToConstant: 35).isActive = true

            spinner.startAnimating()

        }

        return container
    }()//= UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))

    internal var layoutAttributes = [UICollectionViewLayoutAttributes]()
    internal var staticAttributes = [UICollectionViewLayoutAttributes]()

    // MARK: - Layout Setup

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {

        if let oldBounds = collectionView?.bounds {
            if newBounds.width != oldBounds.width {
                // only re-create the static attributes when we have to.
                createStaticAttributes()
            }
        }

        return true
    }

    func createStaticAttributes() {

        if backgroundQueueCount == 0 {
            //addSpinner()
            UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState, animations: {
                self.spinnerContainer.alpha = 1
            }, completion: nil)
        }

        backgroundQueueCount += 1

        self.staticAttributes.removeAll()

        // We do the heavy lifting of creating the layout of the cells on a background queue so it doesnt block the UI
        DispatchQueue.global(qos: .background).async {
            print("Create Attributes on BG Queue")
            var tempAttributes = [UICollectionViewLayoutAttributes]()

            tempAttributes += self.layoutAttributesForCell()

            tempAttributes += self.layoutAttributesForXLabels()

            if self.displayLineConnectors {
                tempAttributes += self.layoutAttributesForLineConnector()
            }

            if self.displayBars {
                tempAttributes += self.layoutAttributesForBar()
            }

            DispatchQueue.main.async {
                self.backgroundQueueCount -= 1

                if self.backgroundQueueCount == 0 {
                    print("Invalidate On Main Queue")

                    self.staticAttributes = tempAttributes

                    self.invalidateLayout()

                    UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState, animations: {
                        self.spinnerContainer.alpha = 0
                    }, completion: nil)
                }
            }
        }
    }

    override public func prepare() {
        // this is called over and over again so create minimal attributes here.

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        tempAttributes += self.layoutAttributesForYDividerLines()

        tempAttributes += self.layoutAttributesForYLabels()

        if ySideBarView != nil {
            tempAttributes += self.layoutAttributesForSideBar()
        }

        layoutAttributes = tempAttributes + staticAttributes
    }

    func layoutAttributesForCell() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        if let collectionView = collectionView {

            for sectionNumber in 0 ..< collectionView.numberOfSections {

                for itemNumber in 0 ..< collectionView.numberOfItems(inSection: sectionNumber) {

                    let indexPath = IndexPath(item: itemNumber, section: sectionNumber)

                    if let attributes = layoutAttributesForItem(at: indexPath) {
                        tempAttributes += [attributes]
                    }
                }
            }
        }
        return tempAttributes
    }

    func layoutAttributesForYDividerLines() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        if let collectionView = collectionView {

            if collectionView.numberOfSections > 0 {
                for number in 0 ..< ySteps {

                    let indexPath = IndexPath(item: number, section: 0)

                    let supplementaryAttribute = layoutAttributesForSupplementaryView(ofKind: ReuseIDs.YDividerView.rawValue, at: indexPath)

                    if let supplementaryAttribute = supplementaryAttribute {
                        tempAttributes += [supplementaryAttribute]
                    }
                }
            }
        }
        return tempAttributes
    }

    func layoutAttributesForYLabels() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        for number in 0 ..< ySteps {

            let indexPath = IndexPath(item: number, section: 0)

            let supplementaryAttribute = layoutAttributesForSupplementaryView(ofKind: ReuseIDs.YLabelView.rawValue, at: indexPath)

            if let supplementaryAttribute = supplementaryAttribute {
                tempAttributes += [supplementaryAttribute]
            }
        }
        return tempAttributes
    }

    func layoutAttributesForXLabels() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        for number in 0 ..< xSteps {

            let indexPath = IndexPath(item: number, section: 0)

            let supplementaryAttribute = layoutAttributesForSupplementaryView(ofKind: ReuseIDs.XLabelView.rawValue, at: indexPath)

            if let supplementaryAttribute = supplementaryAttribute {
                tempAttributes += [supplementaryAttribute]
            }
        }
        return tempAttributes
    }

    func layoutAttributesForLineConnector() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        if let collectionView = collectionView {

            for sectionNumber in 0..<collectionView.numberOfSections {
                for itemNumber in 0 ..< collectionView.numberOfItems(inSection: sectionNumber) {

                    let indexPath = IndexPath(item: itemNumber, section: sectionNumber)

                    let supplementaryAttributes = layoutAttributesForSupplementaryView(ofKind: ReuseIDs.LineConnectorView.rawValue, at: indexPath)

                    if let supplementaryAttributes = supplementaryAttributes {
                        tempAttributes += [supplementaryAttributes]
                    }
                }
            }

            layoutAttributes += tempAttributes
        }
        return tempAttributes
    }

    func layoutAttributesForSideBar() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        if let _ = collectionView {
            let indexPath = IndexPath(item: 0, section: 0)
            let attribute = layoutAttributesForDecorationView(ofKind: ReuseIDs.SideBarView.rawValue, at: indexPath)

            if let attribute = attribute {
                tempAttributes += [attribute]
            }
        }

        return tempAttributes
    }

    func layoutAttributesForBar() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        if let collectionView = collectionView {

            for sectionNumber in 0..<collectionView.numberOfSections {
                for itemNumber in 0 ..< collectionView.numberOfItems(inSection: sectionNumber) {

                    let indexPath = IndexPath(item: itemNumber, section: sectionNumber)

                    let supplementaryAttributes = layoutAttributesForSupplementaryView(ofKind: ReuseIDs.BarView.rawValue, at: indexPath)

                    if let supplementaryAttributes = supplementaryAttributes {
                        tempAttributes += [supplementaryAttributes]
                    }
                }
            }
        }
        return tempAttributes
    }

    // MARK: - Set Attributes

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        if let graphData = graphData, let collectionGraphCellDelegate = collectionGraphCellDelegate {
            cellSize = collectionGraphCellDelegate.collectionGraph(sizeForGraphCellWithData: graphData[indexPath.section][indexPath.item], atIndexPath: indexPath)
        }

        let frame = CGRect(x: xGraphPosition(indexPath: indexPath) - cellSize.width / 2,
                           y: yGraphPosition(indexPath: indexPath) - cellSize.height / 2,
                           width: cellSize.width,
                           height: cellSize.height)

        attributes.frame = frame
        attributes.zIndex = sideBarZIndex - 1 - indexPath.item

        return attributes
    }

    public override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: ReuseIDs.SideBarView.rawValue, with: indexPath)

        if elementKind == ReuseIDs.SideBarView.rawValue {
            if let collectionView = collectionView {

                let width = collectionView.contentInset.left
                let height = collectionView.frame.height
                let verticleInsets = collectionView.contentInset.bottom + collectionView.contentInset.top

                attributes.zIndex = sideBarZIndex

                attributes.frame = CGRect(x: collectionView.contentOffset.x, y: -verticleInsets, width: width, height: height)
            }
        }
        return attributes
    }

    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        if elementKind == ReuseIDs.YDividerView.rawValue {

            return setAttributesForYDivider(fromIndex: indexPath)

        } else if elementKind == ReuseIDs.LineConnectorView.rawValue {

            return setAttributesForLineConnector(fromIndex: indexPath)

        } else if elementKind == ReuseIDs.YLabelView.rawValue {

            return setAttributesForYLabel(fromIndex: indexPath)

        } else if elementKind == ReuseIDs.XLabelView.rawValue {

            return setAttributesForXLabel(fromIndex: indexPath)

        } else if elementKind == ReuseIDs.BarView.rawValue {

            return setAttributesForBar(fromIndex: indexPath)

        }
        return nil
    }

    func setAttributesForYDivider(fromIndex indexPath: IndexPath) -> YDividerLayoutAttributes {

        let attributes = YDividerLayoutAttributes(forSupplementaryViewOfKind: ReuseIDs.YDividerView.rawValue, with: indexPath)

        if let collectionView = collectionView {

            let height = (collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + cellSize.height)) / CGFloat(ySteps)
            let width = collectionView.bounds.width

            let frame = CGRect(x: collectionView.contentOffset.x,
                               y: height * CGFloat(indexPath.row) + cellSize.height / 2,
                               width: width,
                               height: height)

            attributes.frame = frame
            attributes.inset = collectionView.contentInset.left

            attributes.zIndex = -1
        }
        return attributes
    }

    func setAttributesForLineConnector(fromIndex indexPath: IndexPath) -> LineConnectorAttributes? {

        let attributes = LineConnectorAttributes(forSupplementaryViewOfKind: ReuseIDs.LineConnectorView.rawValue, with: indexPath)

        if let graphData = graphData {

            if indexPath.item < graphData[indexPath.section].count - 1 {

                let xOffset = xGraphPosition(indexPath: indexPath)
                let yOffset = yGraphPosition(indexPath: indexPath) - cellSize.height / 2

                let nextIndex = IndexPath(item: indexPath.item + 1, section: indexPath.section)

                let xOffset2 = xGraphPosition(indexPath: nextIndex)
                let yOffset2 = yGraphPosition(indexPath: nextIndex) - cellSize.height / 2

                let p1 = CGPoint(x: xOffset,
                                 y: yOffset)

                let p2 = CGPoint(x: xOffset2,
                                 y: yOffset2)

                // create a Rect between the two points
                if let collectionView = collectionView {

                    let height = collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + cellSize.height)

                    let rect = CGRect(x: min(p1.x, p2.x),
                                      y: cellSize.height / 2,
                                      width: fabs(p1.x - p2.x),
                                      height: height)

                    attributes.frame = rect
                }

                attributes.points = (first: p1, second: p2)

                attributes.zIndex = indexPath.section

                return attributes
            }
        }
        return nil
    }

    func setAttributesForYLabel(fromIndex indexPath: IndexPath) -> XLabelViewAttributes {

        let attributes = XLabelViewAttributes(forSupplementaryViewOfKind: ReuseIDs.YLabelView.rawValue, with: indexPath)

        if let collectionView = collectionView {

            let height = (collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + cellSize.height)) / CGFloat(ySteps)
            let width = collectionView.contentInset.left

            let frame = CGRect(x: collectionView.contentOffset.x,
                               y: (height * CGFloat(indexPath.row)) - (height / 2) + cellSize.height / 2,
                               width: width,
                               height: height)

            attributes.frame = frame

            attributes.zIndex = labelsZIndex

        }
        return attributes
    }

    func setAttributesForXLabel(fromIndex indexPath: IndexPath) -> XLabelViewAttributes {

        let attributes = XLabelViewAttributes(forSupplementaryViewOfKind: ReuseIDs.XLabelView.rawValue, with: indexPath)

        if let collectionView = collectionView {

            let height = collectionView.contentInset.bottom

            let collectionWidth = graphContentWidth ?? collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right + cellSize.width)

            let width = xSteps == 1 ? collectionWidth : collectionWidth / CGFloat(xSteps - 1)

            let xPosition = (width * CGFloat(indexPath.item) - width / 2) + cellSize.width / 2

            let yPosition = collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom

            let frame = CGRect(x: xPosition,
                               y: yPosition,
                               width: width,
                               height: height)

            attributes.frame = frame

            attributes.zIndex = labelsZIndex
        }
        return attributes
    }

     func setAttributesForBar(fromIndex indexPath: IndexPath) -> UICollectionViewLayoutAttributes {

        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: ReuseIDs.BarView.rawValue, with: indexPath)

        var width: CGFloat = cellSize.width

        if let graphData = graphData, let collectionGraphBarDelegate = collectionGraphBarDelegate {
            width = collectionGraphBarDelegate.collectionGraph(widthForBarViewWithData: graphData[indexPath.section][indexPath.item], atIndexPath: indexPath)
        }

        var heightOfCollectionView: CGFloat = 0

        if let collectionView = collectionView {
            heightOfCollectionView = collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + cellSize.height)
        }

        let barHeight = heightOfCollectionView - yGraphPosition(indexPath: indexPath) + cellSize.height / 2
        let yPosition = heightOfCollectionView - (heightOfCollectionView - yGraphPosition(indexPath: indexPath))

        attributes.frame = CGRect(x: xGraphPosition(indexPath: indexPath) - width / 2,
                                  y: yPosition,
                                  width: width,
                                  height: barHeight)

        attributes.zIndex = indexPath.item

        return attributes
    }

    // MARK: - Layout

    public override var collectionViewContentSize: CGSize {
        if let collectionView = collectionView {

            let initialSize = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)

            var width = initialSize

            if let graphContentWidth = graphContentWidth {
                width = graphContentWidth + cellSize.width
            }

            let height = collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + cellSize.height)

            let contentSize = CGSize(width: width, height: height)

            return contentSize
        }

        return CGSize.zero
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var attributesInRect = [UICollectionViewLayoutAttributes]()

        for attributes in layoutAttributes {

            if attributes.frame.intersects(rect) {
                attributesInRect += [attributes]
            }
        }
        return attributesInRect
    }

    // MARK: - Helpers

    func xGraphPosition(indexPath: IndexPath) -> CGFloat {
        if let graphData = graphData, let collectionView = collectionView {

            let width = graphContentWidth ?? collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right + cellSize.width)

            let xRange = xDataRange(graphData: graphData)

            let xDeltaRange = xRange.max - xRange.min

            var xValPercent = (graphData[indexPath.section][indexPath.item].point.x - xRange.min) / xDeltaRange

            if xValPercent.isNaN {
                xValPercent = 0
            }

            let xPos = width * xValPercent + cellSize.width / 2

            return xPos
        }
       return 0
    }

    func yGraphPosition(indexPath: IndexPath) -> CGFloat {
        if let collectionView = collectionView, let graphData = graphData {
            let delta = collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + cellSize.height)

            let yRange = yDataRange(graphData: graphData, numberOfSteps: ySteps)

            let position = delta - (delta * (graphData[indexPath.section][indexPath.item].point.y / yRange.max)) + cellSize.height / 2

            return position.isNaN ? 0 : position
        }
        return 0
    }

}
