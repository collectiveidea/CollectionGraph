//
//  LineGraphLayout.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

@IBDesignable
public class LineGraphLayout: GraphLayout {

    var colors = [UIColor.gray]
    @IBInspectable var straightLines: Bool = false
    @IBInspectable var lineWidth: CGFloat = 1

    override public func prepare() {
        super.prepare()

        if let collectionView = collectionView {

            var tempAttributes = [UICollectionViewLayoutAttributes]()

            for sectionNumber in 0..<collectionView.numberOfSections {
                for itemNumber in 0 ..< collectionView.numberOfItems(inSection: sectionNumber) {

                    let indexPath = IndexPath(item: itemNumber, section: sectionNumber)

                    let supplementaryAttributes = layoutAttributesForSupplementaryView(ofKind: ReuseIDs.LineSupplementaryView.rawValue, at: indexPath)

                    if let supplementaryAttributes = supplementaryAttributes {
                        tempAttributes += [supplementaryAttributes]
                    }
                }
            }

            layoutAttributes += tempAttributes
        }
    }

    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)

        if elementKind == ReuseIDs.LineSupplementaryView.rawValue {
            let attributes = LineConnectorAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
            if let graphData = graphData {

                if indexPath.item < graphData.data[indexPath.section].count - 1 {

                    let xOffset = xGraphPosition(indexPath: indexPath) + cellSize.width / 2
                    let yOffset = yGraphPosition(indexPath: indexPath)

                    let p1 = CGPoint(x: xOffset,
                                     y: yOffset)

                    let nextIndex = IndexPath(item: indexPath.item + 1, section: indexPath.section)

                    let xOffset2 = xGraphPosition(indexPath: nextIndex) + cellSize.width / 2
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

                    attributes.lineWidth = lineWidth
                    attributes.straightLines = straightLines

                    return attributes
                }
            }
        }
        return attributes
    }

}
