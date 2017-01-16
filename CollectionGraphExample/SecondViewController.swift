//
//  SecondViewController.swift
//  CollectionGraphExample
//
//  Created by Chris Rittersdorf on 9/23/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit
import CollectionGraph

class SecondViewController: UIViewController, CollectionGraphCellDelegate, CollectionGraphLineDelegate, CollectionGraphLabelsDelegate, CollectionGraphYDividerLineDelegate, ColorHelpers {

    @IBOutlet weak var graph: CollectionGraphView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setGraphDelegates()

        generalGraphSetup()

        fetchGraphData()
    }

    func generalGraphSetup() {

        graph.ySideBarView = SideBarReusableView()

        graph.ySteps = 5
        graph.xSteps = 50

        graph.leftInset = 60

        graph.graphContentWidth = 9000

        graph.textColor = UIColor(red: 171.0 / 255.0, green: 170.0 / 255.0, blue: 198.0 / 255.0, alpha: 1)
    }

    func setGraphDelegates() {

        graph.collectionGraphCellDelegate = self
        graph.collectionGraphLineDelegate = self
        graph.collectionGraphLabelsDelegate = self
        graph.collectionGraphYDividerLineDelegate = self

    }

    func fetchGraphData() {

        let parser = SmogParser()

        let service = DataService(parser: parser)

        service.fetchData(fromFile: "ppm_sample_data") { (data) in
            self.graph.graphData = data
        }

    }

    // MARK: - Graph Delegates

    // CollectionGraphCellDelegate

    func collectionGraph(cell: UICollectionViewCell, forData data: GraphDatum, atSection section: Int) {

        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = cell.frame.width / 2
    }

    func collectionGraph(sizeForGraphCellWithData data: GraphDatum, inSection section: Int) -> CGSize {
        return CGSize(width: 5, height: 5)
    }

    // CollectionGraphLineDelegate

    func collectionGraph(connectorLine: GraphLineShapeLayer, withData data: GraphDatum, inSection section: Int) {
        connectorLine.strokeColor = colorForSection(section: section).cgColor
    }

    // CollectionGraphLabelsDelegate

    func collectionGraph(textForXLabelWithCurrentText currentText: String, inSection section: Int) -> String {

        let timeInterval = Double(currentText)

        if let timeInterval = timeInterval {
            let date = Date(timeIntervalSince1970: timeInterval)

            let customFormat = DateFormatter.dateFormat(fromTemplate: "MMM d hh:mm", options: 0, locale: Locale(identifier: "us"))!

            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.dateFormat = customFormat

            return formatter.string(from: date)
        }

        return currentText
    }

    // CollectionGraphYDividerLineDelegate

    func collectionGraph(yDividerLine: CAShapeLayer) {
        yDividerLine.lineDashPattern = [1, 8]
        yDividerLine.strokeColor = UIColor(red: 112.0 / 255.0, green: 110.0 / 255.0, blue: 171.0 / 255.0, alpha: 1).cgColor
    }

}
