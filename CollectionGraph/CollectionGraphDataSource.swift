//
//  CollectionGraphDataSource.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class CollectionGraphDataSource: NSObject, UICollectionViewDataSource {

    internal weak var collectionGraphCellDelegate: CollectionGraphCellDelegate?
    internal weak var collectionGraphBarDelegate: CollectionGraphBarDelegate?
    internal weak var collectionGraphLineDelegate: CollectionGraphLineDelegate?
    internal weak var collectionGraphLineFillDelegate: CollectionGraphLineFillDelegate?
    internal weak var collectionGraphLabelsDelegate: CollectionGraphLabelsDelegate?

    var graphData: [[GraphDatum]]?

    internal var yDividerLineColor: UIColor = UIColor.lightGray

    internal var textColor: UIColor = UIColor.darkText

    internal var textSize: CGFloat = 8

    internal var fontName: String?

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return graphData?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return graphData?[section].count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIDs.GraphCell.rawValue, for: indexPath)

        if let graphData = graphData {
            collectionGraphCellDelegate?.collectionGraph(cell: cell, forData: graphData[indexPath.section][indexPath.item], atSection: indexPath.section)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case ReuseIDs.YDividerView.rawValue:

            let yDividerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.YDividerView.rawValue, for: indexPath)

            yDividerViewSetup(yDividerView: yDividerView)

            return yDividerView

        case ReuseIDs.LineConnectorView.rawValue:

            let line = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.LineConnectorView.rawValue, for: indexPath)

            lineConnectorViewSetup(line: line, indexPath: indexPath)

            return line

        case ReuseIDs.YLabelView.rawValue:

            let labelView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.YLabelView.rawValue, for: indexPath)

            yLabelViewSetup(labelView: labelView)

            return labelView

        case ReuseIDs.XLabelView.rawValue:

            let labelView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.XLabelView.rawValue, for: indexPath)

            xLabelViewSetup(labelView: labelView, indexPath: indexPath)

            return labelView

        case ReuseIDs.BarView.rawValue:

            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.BarView.rawValue, for: indexPath)

            barViewSetup(barView: view, indexPath: indexPath)

            return view

        case ReuseIDs.SideBarView.rawValue:

            let sideBar = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.SideBarView.rawValue, for: indexPath)

            return sideBar

        default:

            return UICollectionReusableView()
        }
    }

    func yDividerViewSetup(yDividerView: UICollectionReusableView) {
        if let yDividerView = yDividerView as? YDividerLineView {
            yDividerView.line.strokeColor = yDividerLineColor.cgColor
        }
    }

    func lineConnectorViewSetup(line: UICollectionReusableView, indexPath: IndexPath) {
        if let line = line as? LineConnectorView, let graphData = graphData {

            collectionGraphLineDelegate?.collectionGraph(connectorLine: line.line, withData: graphData[indexPath.section][indexPath.item], inSection: indexPath.section)

            line.fillColor = collectionGraphLineFillDelegate?.collectionGraph(fillColorForGraphSectionWithData: graphData[indexPath.section][indexPath.item], inSection: indexPath.section)
        }
    }

    func yLabelViewSetup(labelView: UICollectionReusableView) {
        if let labelView = labelView as? LabelView {

            if let fontName = fontName {
                labelView.label.font = UIFont(name: fontName, size: textSize)
            } else {
                labelView.label.font = UIFont(name: labelView.label.font.fontName, size: textSize)
            }

            labelView.label.textColor = textColor
        }
    }

    func xLabelViewSetup(labelView: UICollectionReusableView, indexPath: IndexPath) {
        if let labelView = labelView as? LabelView {

            if let fontName = fontName {
                labelView.label.font = UIFont(name: fontName, size: textSize)
            } else {
                labelView.label.font = UIFont(name: labelView.label.font.fontName, size: textSize)
            }

            labelView.label.textColor = textColor

            if let collectionGraphLabelsDelegate = collectionGraphLabelsDelegate {
                labelView.label.text = collectionGraphLabelsDelegate.collectionGraph(textForXLabelWithCurrentText: labelView.label.text!, inSection: indexPath.item)
            }
        }
    }

    func barViewSetup(barView: UICollectionReusableView, indexPath: IndexPath) {
        if let graphData = graphData {

            collectionGraphBarDelegate?.collectionGraph(barView: barView, withData: graphData[indexPath.section][indexPath.item], inSection: indexPath.section)
        }
    }

}
