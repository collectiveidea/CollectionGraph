//
//  CollectionGraphDataSource.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class CollectionGraphDataSource: NSObject, UICollectionViewDataSource {

    var graphData: [[GraphDatum]]?

    internal var cellCallback: ((_ cell: UICollectionViewCell, _ data: GraphDatum) -> ())?

    internal var barCallback: ((_ cell: UICollectionReusableView, _ data: GraphDatum) -> ())?

    internal var lineCallback: ((_ line: GraphLineShapeLayer, _ data: GraphDatum) -> ())?

    internal var yDividerLineColor: UIColor = UIColor.lightGray

    internal var textColor: UIColor = UIColor.darkText
    
    internal var textSize: CGFloat = 8

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return graphData?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return graphData?[section].count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIDs.GraphCell.rawValue, for: indexPath)

        if let graphData = graphData, let cellCallback = cellCallback {
            cellCallback(cell, graphData[indexPath.section][indexPath.item])
        }

        cell.layer.zPosition = 10

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case ReuseIDs.YDividerView.rawValue:
            let yDividerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.YDividerView.rawValue, for: indexPath)

            if let yDividerView = yDividerView as? YDividerLineView {
                yDividerView.label.font = UIFont(name: yDividerView.label.font.fontName, size: textSize)
                yDividerView.label.textColor = textColor
                yDividerView.line.strokeColor = yDividerLineColor.cgColor
            }

            return yDividerView

        case ReuseIDs.LineConnectorView.rawValue:

            let line = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.LineConnectorView.rawValue, for: indexPath)

            if let line = line as? LineConnectorView, let graphData = graphData, let lineCallback = lineCallback {
                lineCallback(line.line, graphData[indexPath.section][indexPath.item])
            }

            return line

        case ReuseIDs.XLabelView.rawValue:

            let xLabelView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.XLabelView.rawValue, for: indexPath)

            if let xLabelView = xLabelView as? XLabelView {
                xLabelView.label.font = UIFont(name: xLabelView.label.font.fontName, size: textSize)
                xLabelView.label.textColor = textColor
            }

            return xLabelView

        case ReuseIDs.BarView.rawValue:

            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.BarView.rawValue, for: indexPath)

            if let graphData = graphData, let barCallback = barCallback {
                barCallback(view, graphData[indexPath.section][indexPath.item])
            }

            return view

        default:

            return UICollectionReusableView()
        }
    }

}
