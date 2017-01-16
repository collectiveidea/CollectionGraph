//
//  FirstViewController.swift
//  CollectionGraphExample
//
//  Created by Chris Rittersdorf on 9/23/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit
import CollectionGraph

class FirstViewController: UIViewController, CollectionGraphViewDelegate, CollectionGraphCellDelegate, CollectionGraphLineDelegate, CollectionGraphLineFillDelegate, CollectionGraphLabelsDelegate, CollectionGraphYDividerLineDelegate, ColorHelpers {

    @IBOutlet weak var graph: CollectionGraphView!

    override func viewDidLoad() {
        super.viewDidLoad()

        graph.collectionGraphViewDelegate = self
        graph.collectionGraphCellDelegate = self
        graph.collectionGraphLineDelegate = self
        graph.collectionGraphLineFillDelegate = self
        graph.collectionGraphLabelsDelegate = self
        graph.collectionGraphYDividerLineDelegate = self

        // Change the Font of the X and Y labels
        // graph.fontName = "chalkduster"

        graph.ySideBarView = SideBarReusableView()

        // Provide a custom cell with a user image property
        graph.graphCell = PeopleCollectionViewCell()

        let service = GraphDataService()

        graph.ySteps = 5

        graph.textColor = UIColor(red: 171.0 / 255.0, green: 170.0 / 255.0, blue: 198.0 / 255.0, alpha: 1)

//        graph.yDividerLineColor = UIColor(red: 112.0 / 255.0, green: 110.0 / 255.0, blue: 171.0 / 255.0, alpha: 1)

        service.fetchMilesPerDayDatum(completion: { [weak self] data in

            self?.graph.graphData = data

            // each set of data has the same amount of data points so we'll just use the count from the first set
            self?.graph.xSteps = data[0].count

            // Adjusts the width of the graph.  The Cells are spaced out depending on this size
            self?.graph.graphContentWidth = 800

            // self.graph.scrollToDataPoint(graphDatum: self.graph.graphData![0].last!, withAnimation: true, andScrollPosition: .centeredHorizontally)

            // self.graph.contentOffset = CGPoint(x: 30, y: self.graph.contentOffset.y)
        })
    }

    // MARK: - Graph Delegates

    // CollectionGraphViewDelegate

    func collectionGraph(updatedVisibleIndexPaths indexPaths: Set<IndexPath>, sections: Set<Int>) {
        indexPaths.forEach {
             let data = self.graph.graphData?[$0.section][$0.item]
             print("Data: \(data)")
        }
    }

    // CollectionGraphCellDelegate

    func collectionGraph(cell: UICollectionViewCell, forData data: GraphDatum, atSection section: Int) {

        if let peopleCell = cell as? PeopleCollectionViewCell {

            if let data = data as? MilesPerDayDatum {

                let imageName = data.imageName
                peopleCell.image = UIImage(named: imageName) ?? UIImage()
            }

        }

        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = colorForSection(section: section).cgColor
        cell.layer.cornerRadius = cell.frame.width / 2
    }

    func collectionGraph(sizeForGraphCellWithData data: GraphDatum, inSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 20)
    }

    // CollectionGraphLineDelegate

    func collectionGraph(connectorLine: GraphLineShapeLayer, withData data: GraphDatum, inSection section: Int) {
        // connectorLine.lineWidth = 2
        // connectorLine.lineDashPattern = [4, 2]
        // connectorLine.straightLines = true
        // connectorLine.lineCap = kCALineCapRound
        connectorLine.strokeColor = colorForSection(section: section).cgColor
    }

    // CollectionGraphLineFillDelegate

    func collectionGraph(fillColorForGraphSectionWithData data: GraphDatum, inSection section: Int) -> UIColor {
        return colorForSection(section: section).withAlphaComponent(0.1)
    }

    // CollectionGraphLabelsDelegate

    func collectionGraph(textForXLabelWithCurrentText currentText: String, inSection section: Int) -> String {

        let timeInterval = Double(currentText)

        if let timeInterval = timeInterval {
            let date = Date(timeIntervalSince1970: timeInterval)

            let customFormat = DateFormatter.dateFormat(fromTemplate: "MMM d", options: 0, locale: Locale(identifier: "us"))!

            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.dateFormat = customFormat

            return formatter.string(from: date)
        }

        //return "•"
        return currentText
    }

    // CollectionGraphYDividerLineDelegate

    func collectionGraph(yDividerLine: CAShapeLayer) {
        yDividerLine.lineDashPattern = [1, 8]
        yDividerLine.strokeColor = UIColor(red: 112.0 / 255.0, green: 110.0 / 255.0, blue: 171.0 / 255.0, alpha: 1).cgColor
        // yDividerLine.lineWidth = 2
    }

}
