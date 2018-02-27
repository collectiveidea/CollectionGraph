//
//  CollectionGraphDataSource.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class CollectionGraphDataSource: NSObject, UICollectionViewDataSource, RangeFinder {

    internal weak var collectionGraphCellDelegate: CollectionGraphCellDelegate?
    internal weak var collectionGraphBarDelegate: CollectionGraphBarDelegate?
    internal weak var collectionGraphLineDelegate: CollectionGraphLineDelegate?
    internal weak var collectionGraphLineFillDelegate: CollectionGraphLineFillDelegate?
    internal weak var collectionGraphLabelsDelegate: CollectionGraphLabelsDelegate?
    internal weak var collectionGraphYDividerLineDelegate: CollectionGraphYDividerLineDelegate?

    var graphData: [[GraphDatum]]?

    internal var yDividerLineColor: UIColor = UIColor.lightGray

    internal var textColor: UIColor = UIColor.darkText

    internal var textSize: CGFloat = 8

    internal var fontName: String?

    internal var ySteps: Int = 6
    internal var xSteps: Int = 3

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let graphData = graphData else {
            return 1
        }
        
        let sectionCount = graphData.count == 0 ? 1 : graphData.count
        return sectionCount
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let graphData = graphData else {
            return 0
        }
        
        if graphData.isEmpty {
            return 0
        }
        
        return graphData[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIDs.graphCell.rawValue, for: indexPath)

        if let graphData = graphData {
            collectionGraphCellDelegate?.collectionGraph(cell: cell, forData: graphData[indexPath.section][indexPath.item], atIndexPath: indexPath)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case ReuseIDs.yDividerView.rawValue:

            let yDividerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.yDividerView.rawValue, for: indexPath)

            yDividerViewSetup(yDividerView: yDividerView, indexPath: indexPath)

            return yDividerView

        case ReuseIDs.lineConnectorView.rawValue:

            let line = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.lineConnectorView.rawValue, for: indexPath)

            lineConnectorViewSetup(line: line, indexPath: indexPath)

            return line

        case ReuseIDs.yLabelView.rawValue:

            let labelView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.yLabelView.rawValue, for: indexPath)

            yLabelViewSetup(labelView: labelView, indexPath: indexPath)

            return labelView

        case ReuseIDs.xLabelView.rawValue:

            let labelView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.xLabelView.rawValue, for: indexPath)

            xLabelViewSetup(labelView: labelView, indexPath: indexPath)

            return labelView

        case ReuseIDs.barView.rawValue:

            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.barView.rawValue, for: indexPath)

            barViewSetup(barView: view, indexPath: indexPath)

            return view

        case ReuseIDs.sideBarView.rawValue:

            let sideBar = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.sideBarView.rawValue, for: indexPath)

            return sideBar

        default:

            return UICollectionReusableView()
        }
    }

    func yDividerViewSetup(yDividerView: UICollectionReusableView, indexPath: IndexPath) {
        if let yDividerView = yDividerView as? YDividerLineView {
            yDividerView.line.strokeColor = yDividerLineColor.cgColor

            collectionGraphYDividerLineDelegate?.collectionGraph(yDividerLine: yDividerView.line, atItem: indexPath.item)
        }
    }

    func lineConnectorViewSetup(line: UICollectionReusableView, indexPath: IndexPath) {
        if let line = line as? LineConnectorView, let graphData = graphData {

            collectionGraphLineDelegate?.collectionGraph(connectorLine: line.line, withData: graphData[indexPath.section][indexPath.item], atIndexPath: indexPath)

            line.fillColor = collectionGraphLineFillDelegate?.collectionGraph(fillColorForGraphSectionWithData: graphData[indexPath.section][indexPath.item], atIndexPath: indexPath)
        }
    }

    func yLabelViewSetup(labelView: UICollectionReusableView, indexPath: IndexPath) {
        if let labelView = labelView as? LabelView, let graphData = graphData {

            if let fontName = fontName {
                labelView.label.font = UIFont(name: fontName, size: textSize)
            } else {
                labelView.label.font = UIFont(name: labelView.label.font.fontName, size: textSize)
            }

            labelView.label.textColor = textColor

            let yRange = yDataRange(graphData: graphData, numberOfSteps: ySteps)

            let amountPerStep = yRange.max / CGFloat(ySteps)

            let yText = "\(Int((yRange.max - (amountPerStep * CGFloat(indexPath.item)))))"
            labelView.label.text = yText
        }
    }

    func xLabelViewSetup(labelView: UICollectionReusableView, indexPath: IndexPath) {
        if let labelView = labelView as? LabelView, let graphData = graphData {

            if let fontName = fontName {
                labelView.label.font = UIFont(name: fontName, size: textSize)
            } else {
                labelView.label.font = UIFont(name: labelView.label.font.fontName, size: textSize)
            }

            labelView.label.textColor = textColor

            let range = xDataRange(graphData: graphData)
            let xDelta = range.max - range.min

            var stepAmount = xDelta / CGFloat(xSteps - 1)

            if stepAmount.isNaN { stepAmount = 1 }

            let labelText = "\(stepAmount * CGFloat(indexPath.item) + range.min)"

            if let collectionGraphLabelsDelegate = collectionGraphLabelsDelegate {
                labelView.label.text = collectionGraphLabelsDelegate.collectionGraph(textForXLabelWithCurrentText: labelText, item: indexPath.item)
            } else {
                labelView.label.text = labelText
            }
        }
    }

    func barViewSetup(barView: UICollectionReusableView, indexPath: IndexPath) {
        if let graphData = graphData {

            collectionGraphBarDelegate?.collectionGraph(barView: barView, withData: graphData[indexPath.section][indexPath.item], atIndexPath: indexPath)
        }
    }

}
