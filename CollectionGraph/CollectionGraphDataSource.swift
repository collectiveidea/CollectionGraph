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

    internal var cellCallback: ((_ cell: UICollectionViewCell, _ data: GraphDatum, _ section: Int) -> ())?

    internal var barCallback: ((_ cell: UICollectionReusableView, _ data: GraphDatum, _ section: Int) -> ())?

    internal var lineCallback: ((_ line: GraphLineShapeLayer, _ data: GraphDatum, _ section: Int) -> ())?
    
    internal var xLabelCallback: ((_ currentString: String, _ section: Int) -> (String))?

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

        if let graphData = graphData, let cellCallback = cellCallback {
            cellCallback(cell, graphData[indexPath.section][indexPath.item], indexPath.section)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case ReuseIDs.YDividerView.rawValue:
            let yDividerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.YDividerView.rawValue, for: indexPath)

            if let yDividerView = yDividerView as? YDividerLineView {
                yDividerView.line.strokeColor = yDividerLineColor.cgColor
            }

            return yDividerView

        case ReuseIDs.LineConnectorView.rawValue:

            let line = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.LineConnectorView.rawValue, for: indexPath)

            if let line = line as? LineConnectorView, let graphData = graphData, let lineCallback = lineCallback {
                lineCallback(line.line, graphData[indexPath.section][indexPath.item], indexPath.section)
            }

            return line
            
        case ReuseIDs.YLabelView.rawValue:
            
            let labelView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.YLabelView.rawValue, for: indexPath)
            
            if let labelView = labelView as? LabelView {
                
                if let fontName = fontName {
                    labelView.label.font = UIFont(name: fontName, size: textSize)
                } else {
                    labelView.label.font = UIFont(name: labelView.label.font.fontName, size: textSize)
                }
                
                labelView.label.textColor = textColor
            }

            return labelView

        case ReuseIDs.XLabelView.rawValue:

            let labelView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.XLabelView.rawValue, for: indexPath)

            if let labelView = labelView as? LabelView {
                
                if let fontName = fontName {
                    labelView.label.font = UIFont(name: fontName, size: textSize)
                } else {
                    labelView.label.font = UIFont(name: labelView.label.font.fontName, size: textSize)
                }
                
                labelView.label.textColor = textColor
                
                if let xLabelCallback = xLabelCallback {
                    labelView.label.text = xLabelCallback(labelView.label.text!, indexPath.item)
                }
            }

            return labelView

        case ReuseIDs.BarView.rawValue:

            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.BarView.rawValue, for: indexPath)

            if let graphData = graphData, let barCallback = barCallback {
                barCallback(view, graphData[indexPath.section][indexPath.item], indexPath.section)
            }

            return view

        default:

            return UICollectionReusableView()
        }
    }

}
