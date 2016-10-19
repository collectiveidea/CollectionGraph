//
//  GraphLayout.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

public protocol GraphLayoutConfigurable {
    var graphWidth: CGFloat? { get set }
    var ySteps: Int { get }
    var xSteps: Int { get }

    func cellSize(fromData data: GraphData) -> CGSize
}

public protocol LineGraphLayoutConfigurable: GraphLayoutConfigurable {
    var straightLines: Bool { get }

    func lineWidth(fromData data: GraphData) -> CGFloat
}

public protocol BarGraphLayoutConfigurable: GraphLayoutConfigurable {

}


public class GraphLayout: UICollectionViewLayout {

    public var config: GraphLayoutConfigurable!

    private var xDataRange: CGFloat = 0
    private var yDataRange: CGFloat = 0

    private var minXVal: CGFloat = 0

    private var yIncrements: CGFloat {
        get {
            return  yDataRange / CGFloat(config.ySteps)
        }
    }

    internal var graphData: [GraphData]? {
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

    public required init(config: GraphLayoutConfigurable) {
        super.init()
        self.config = config
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func prepare() {

        if let collectionView = collectionView {

            var tempAttributes = [UICollectionViewLayoutAttributes]()

            for sectionNumber in 0 ..< collectionView.numberOfSections {

                for itemNumber in 0 ..< collectionView.numberOfItems(inSection: sectionNumber) {

                    let indexPath = IndexPath(item: itemNumber, section: sectionNumber)

                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                    let cellSize = cell(sizeAtIndex: indexPath)

                    let frame = CGRect(x: xGraphPosition(indexPath: indexPath) - cellSize.width / 2, y: yGraphPosition(indexPath: indexPath) - cellSize.height / 2, width: cellSize.width, height: cellSize.height)

                    attributes.frame = frame

                    tempAttributes += [attributes]
                }
            }

            for number in 0 ..< config.ySteps {

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

            let width = config.graphWidth ?? collectionView.bounds.width
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

                let height = (collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom) / CGFloat(config.ySteps)

                let frame = CGRect(x: collectionView.contentOffset.x,
                                   y: height * CGFloat(indexPath.row),
                                   width: collectionView.frame.width,
                                   height: height)

                attributes.frame = frame
                attributes.inset = collectionView.contentInset.left

                attributes.text = "\(Int((yIncrements * CGFloat(config.ySteps)) - (yIncrements * CGFloat(indexPath.row))))"
            }
            return attributes
        }
        return nil
    }

    // MARK: - Helpers

    func cell(sizeAtIndex indexPath: IndexPath) -> CGSize {
        if let graphData = graphData {
            return config.cellSize(fromData: graphData[indexPath.item])
        }
        return CGSize.zero
    }

    func calculateXDataRange() {
        let xVals = graphData?.map {
            return $0.point.x
        }
        if let min = xVals?.min(), let max = xVals?.max() {
            xDataRange = max - min
            minXVal = min
        }
    }

    func calculateYDataRange() {

        let yVals = graphData?.map {
            return $0.point.y
        }

        let maxY = yVals?.max() ?? 0

        let remainder = maxY.truncatingRemainder(dividingBy: CGFloat(config.ySteps))
        if remainder == 0 {
            yDataRange = maxY
        } else {
            yDataRange = maxY - remainder + CGFloat(config.ySteps)
        }
    }

    func xGraphPosition(indexPath: IndexPath) -> CGFloat {
        if let graphData = graphData, let collectionView = collectionView {

            let width = config.graphWidth ?? collectionView.bounds.width

            let xValPercent = (graphData.filterBySection(indexPath.section)[indexPath.item].point.x - minXVal) / xDataRange
            let xPos = width * xValPercent
            return xPos
        }
       return 0
    }

    func yGraphPosition(indexPath: IndexPath) -> CGFloat {
        if let collectionView = collectionView, let graphData = graphData {
            let delta = collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom

            return delta - (delta * (graphData.filterBySection(indexPath.section)[indexPath.item].point.y / yDataRange))
        }
        return 0
    }

}
