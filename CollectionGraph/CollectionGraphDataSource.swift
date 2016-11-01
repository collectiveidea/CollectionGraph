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

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case ReuseIDs.YDividerView.rawValue:

            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.YDividerView.rawValue, for: indexPath)

        case ReuseIDs.LineConnectorView.rawValue:

            let line = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.LineConnectorView.rawValue, for: indexPath)
            
            if let line = line as? LineConnectorView, let graphData = graphData, let lineCallback = lineCallback {
                lineCallback(line.line, graphData[indexPath.section][indexPath.item])
            }
            
            return line

        case ReuseIDs.XLabelView.rawValue:

            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIDs.XLabelView.rawValue, for: indexPath)
            
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
