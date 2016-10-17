//
//  GraphLayout.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

public class GraphLayout: UICollectionViewLayout {

    @IBInspectable var cellSize: CGSize = CGSize(width: 3.0, height: 3.0)

    @IBInspectable public var ySteps: Int = 6
    @IBInspectable public var xSteps: Int = 3

    @IBInspectable public var graphWidth: CGFloat? // width of graph in points

    private var xDataRange: CGFloat = 0
    private var yDataRange: CGFloat = 0

    private var minXVal: CGFloat = 0

    private var yIncrements: CGFloat {
        get {
            return  yDataRange / CGFloat(ySteps)
        }
    }

    internal var graphData: [[GraphData]]? {
        didSet {
            calculateXDataRange()
            calculateYDataRange()
        }
    }

    internal var layoutAttributes = [UICollectionViewLayoutAttributes]()

    // MARK: - Layout Setup

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override public func prepare() {

        if let collectionView = collectionView {

            var tempAttributes = [UICollectionViewLayoutAttributes]()

            for sectionNumber in 0 ..< collectionView.numberOfSections {

                for itemNumber in 0 ..< collectionView.numberOfItems(inSection: sectionNumber) {

                    let indexPath = IndexPath(item: itemNumber, section: sectionNumber)

                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                    let frame = CGRect(x: xGraphPosition(indexPath: indexPath) - cellSize.width / 2, y: yGraphPosition(indexPath: indexPath) - cellSize.height / 2, width: cellSize.width, height: cellSize.height)

                    attributes.frame = frame

                    tempAttributes += [attributes]
                }
            }

            for number in 0 ..< ySteps {

                let indexPath = IndexPath(item: number, section: 0)

                let supplementaryAttribute = layoutAttributesForSupplementaryView(ofKind: ReuseIDs.YDividerSupplementaryView.rawValue, at: indexPath)

                if let supplementaryAttribute = supplementaryAttribute {
                    tempAttributes += [supplementaryAttribute]
                }
            }

            layoutAttributes = tempAttributes
        }
    }

    // MARK: - Layout

    public override var collectionViewContentSize: CGSize {
        if let collectionView = collectionView {

            let width = graphWidth ?? collectionView.bounds.width
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

    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        if elementKind == ReuseIDs.YDividerSupplementaryView.rawValue {
            let attributes = YDividerLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)

            if let collectionView = collectionView {

                let height = (collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom) / CGFloat(ySteps)

                let frame = CGRect(x: collectionView.contentOffset.x,
                                   y: height * CGFloat(indexPath.row),
                                   width: collectionView.frame.width,
                                   height: height)

                attributes.frame = frame
                attributes.inset = collectionView.contentInset.left

                attributes.text = "\(Int((yIncrements * CGFloat(ySteps)) - (yIncrements * CGFloat(indexPath.row))))"
            }
            return attributes
        }
        return nil
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

        let remainder = maxY.truncatingRemainder(dividingBy: CGFloat(ySteps))
        if remainder == 0 {
            yDataRange = maxY
        } else {
            yDataRange = maxY - remainder + CGFloat(ySteps)
        }
    }

    func xGraphPosition(indexPath: IndexPath) -> CGFloat {
        if let graphData = graphData, let collectionView = collectionView {

            let width = graphWidth ?? collectionView.bounds.width

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
