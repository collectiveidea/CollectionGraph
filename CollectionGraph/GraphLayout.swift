//
//  GraphLayout.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

public class GraphLayout: UICollectionViewLayout {
    
    internal var graphData: [[GraphDatum]]? {
        didSet {
            calculateXDataRange()
            calculateYDataRange()
        }
    }

    internal var cellLayoutCallback: ((_ data: GraphDatum) -> (CGSize))?
    internal var barLayoutCallback: ((_ data: GraphDatum) -> (CGFloat))?

    internal var ySteps: Int = 6
    internal var xSteps: Int = 3

    internal var graphWidth: CGFloat? // width of graph in points
    
    internal var cellSize: CGSize = CGSize(width: 3.0, height: 3.0)

    private var xDataRange: CGFloat = 0
    private var yDataRange: CGFloat = 0

    private var minXVal: CGFloat = 0

    private var yIncrements: CGFloat {
        get {
            return  yDataRange / CGFloat(ySteps)
        }
    }

    internal var layoutAttributes = [UICollectionViewLayoutAttributes]()

    // MARK: - Layout Setup

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override public func prepare() {
        var tempAttributes = [UICollectionViewLayoutAttributes]()

        tempAttributes += layoutAttributesForCell()
        tempAttributes += layoutAttributesForYDividerLines()
        tempAttributes += layoutAttributesForLineConnector()
        tempAttributes += layoutAttributesForXLabel()
        tempAttributes += layoutAttributesForBar()

        layoutAttributes = tempAttributes
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

    func layoutAttributesForXLabel() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()
        
        for number in 0..<xSteps {
            
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

//            for number in 0 ..< ySteps {
//
//                let indexPath = NSIndexPath(forItem: number, inSection: 0)
//                
//                let supplementaryAttribute = layoutAttributesForSupplementaryViewOfKind(String(YDividerLineView), atIndexPath: indexPath)
//                
//                if let supplementaryAttribute = supplementaryAttribute {
//                    tempAttributes += [supplementaryAttribute]
//                }
//            }
//            
//            for number in 0...numberOfXDividerLines {
//                
//                let indexPath = NSIndexPath(forItem: number, inSection: 0)
//                
//                let supplementaryAttribute = layoutAttributesForSupplementaryViewOfKind(String(XDataView), atIndexPath: indexPath)
//                
//                if let supplementaryAttribute = supplementaryAttribute {
//                    tempAttributes += [supplementaryAttribute]
//                }
//            }
            
            layoutAttributes += tempAttributes
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

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        if let graphData = graphData, let layoutCallback = cellLayoutCallback {
            cellSize = layoutCallback(graphData[indexPath.section][indexPath.item])
        }
        
        let frame = CGRect(x: xGraphPosition(indexPath: indexPath) - cellSize.width / 2, y: yGraphPosition(indexPath: indexPath) - cellSize.height / 2, width: cellSize.width, height: cellSize.height)
        
        attributes.frame = frame
        
        return attributes
    }
    
    // MARK: Set Attributes

    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if elementKind == ReuseIDs.YDividerView.rawValue {
            
            return setAttributesForYDivider(fromIndex: indexPath)
        
        } else if elementKind == ReuseIDs.LineConnectorView.rawValue {
            
            return setAttributesForLineConnector(fromIndex: indexPath)
            
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
            
            let height = (collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom) / CGFloat(ySteps)
            let width = collectionView.bounds.width
            
            let frame = CGRect(x: collectionView.contentOffset.x,
                               y: height * CGFloat(indexPath.row),
                               width: width,
                               height: height)
            
            attributes.frame = frame
            attributes.inset = collectionView.contentInset.left
            
            attributes.text = "\(Int((yIncrements * CGFloat(ySteps)) - (yIncrements * CGFloat(indexPath.row))))"
        }
        return attributes
    }
    
    func setAttributesForLineConnector(fromIndex indexPath: IndexPath) -> LineConnectorAttributes? {
        
        let attributes = LineConnectorAttributes(forSupplementaryViewOfKind: ReuseIDs.LineConnectorView.rawValue, with: indexPath)
        
        if let graphData = graphData {
            
            if indexPath.item < graphData[indexPath.section].count - 1 {
                
                let xOffset = xGraphPosition(indexPath: indexPath)
                let yOffset = yGraphPosition(indexPath: indexPath)
                
                let p1 = CGPoint(x: xOffset,
                                 y: yOffset)
                
                let nextIndex = IndexPath(item: indexPath.item + 1, section: indexPath.section)
                
                let xOffset2 = xGraphPosition(indexPath: nextIndex)
                let yOffset2 = yGraphPosition(indexPath: nextIndex)
                
                let p2 = CGPoint(x: xOffset2,
                                 y: yOffset2)
                
                // create a Rect between the two points
                let rect = CGRect(x: min(p1.x, p2.x),
                                  y: min(p1.y, p2.y),
                                  width: fabs(p1.x - p2.x),
                                  height: fabs(p1.y - p2.y))
                
                attributes.frame = rect
                
                // decide which way the line should go
                attributes.lineStartsAtTop =
                    (xOffset < xOffset2 && yOffset > yOffset2) ||
                    (xOffset > xOffset2 && yOffset < yOffset2)
                    ? false : true
                
                //                    attributes.lineWidth = lineWidth
                //                    attributes.straightLines = straightLines
                
                return attributes
            }
        }
        return nil
    }
    
    func setAttributesForXLabel(fromIndex indexPath: IndexPath) -> XLabelViewAttributes {
        
        let attributes = XLabelViewAttributes(forSupplementaryViewOfKind: ReuseIDs.XLabelView.rawValue, with: indexPath)
        
        if let collectionView = collectionView {
            
            let height = collectionView.contentInset.bottom
            let collectionWidth = graphWidth ?? collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
            
            var width: CGFloat = 0
            var xPosition: CGFloat = 0
            
            if xSteps == 1 {
                width = collectionWidth
                attributes.text = "\(xDataRange * CGFloat(indexPath.item) + minXVal)"
                xPosition = collectionWidth / 2
            } else {
                width = collectionWidth / CGFloat(xSteps - 1)
                attributes.text = "\(xDataRange / CGFloat(xSteps - 1) * CGFloat(indexPath.item) + minXVal)"
                xPosition = width * CGFloat(indexPath.item) - width / 2
            }
            
            let yPosition = collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom
            
            let frame = CGRect(x: xPosition,
                               y: yPosition,
                               width: width,
                               height: height)
            
            attributes.frame = frame
        }
        return attributes
    }
    
     func setAttributesForBar(fromIndex indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: ReuseIDs.BarView.rawValue, with: indexPath)
        
        var width: CGFloat = cellSize.width
        
        if let graphData = graphData, let layoutCallback = barLayoutCallback {
            width = layoutCallback(graphData[indexPath.section][indexPath.item])
        }

        var heightOfCollectionView:CGFloat = 0
        
        if let collectionView = collectionView {
            heightOfCollectionView = collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        }
        
        let barHeight = heightOfCollectionView - yGraphPosition(indexPath: indexPath)
        let yPosition = heightOfCollectionView - (heightOfCollectionView - yGraphPosition(indexPath: indexPath))
        
        attributes.frame = CGRect(x: xGraphPosition(indexPath: indexPath) - width / 2, y: yPosition, width: width, height: barHeight)
        
        return attributes
    }

    // MARK: - Layout

    public override var collectionViewContentSize: CGSize {
        if let collectionView = collectionView {

            let width = graphWidth ?? collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
            let height = collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)

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

    func calculateXDataRange() {
        let xVals = graphData?.flatMap {
            return $0.map { return $0.point.x }
        }
        if let min = xVals?.min(), let max = xVals?.max() {
            xDataRange = max - min
            minXVal = min
        }
    }

    func calculateYDataRange() {

        let yVals = graphData?.flatMap {
            return $0.map { return $0.point.y }
        }

        let maxY = yVals?.max() ?? 0

        var remainder = maxY.truncatingRemainder(dividingBy: CGFloat(ySteps))
        if remainder.isNaN {
            remainder = 0
        }
        if remainder == 0 {
            yDataRange = maxY
        } else {
            yDataRange = maxY - remainder + CGFloat(ySteps)
        }
    }

    func xGraphPosition(indexPath: IndexPath) -> CGFloat {
        if let graphData = graphData, let collectionView = collectionView {

            let width = graphWidth ?? collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)

            let xValPercent = (graphData[indexPath.section][indexPath.item].point.x - minXVal) / xDataRange
            let xPos = width * xValPercent

            return xPos
        }
       return 0
    }

    func yGraphPosition(indexPath: IndexPath) -> CGFloat {
        if let collectionView = collectionView, let graphData = graphData {
            let delta = collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom

            return delta - (delta * (graphData[indexPath.section][indexPath.item].point.y / yDataRange))
        }
        return 0
    }

}
