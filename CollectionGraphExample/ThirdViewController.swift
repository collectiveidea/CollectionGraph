//
//  ThirdViewController.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 1/19/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import UIKit
import CollectionGraph

class ThirdViewController: UIViewController, CollectionGraphCellDelegate, CollectionGraphLabelsDelegate, CollectionGraphYDividerLineDelegate, ColorHelpers {

    @IBOutlet weak var graph: CollectionGraphView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setGraphDelegates()

        generalGraphSetup()

        fetchGraphData()
    }

    func generalGraphSetup() {

        graph.ySideBarView = SideBarReusableView()

        graph.ySteps = 10

        graph.textColor = UIColor(red: 171.0 / 255.0, green: 170.0 / 255.0, blue: 198.0 / 255.0, alpha: 1)

        // Provide a custom cell with a user image property
        graph.graphCell = PeopleCollectionViewCell()

        graph.yDividerLineColor = UIColor(red: 112.0 / 255.0, green: 110.0 / 255.0, blue: 171.0 / 255.0, alpha: 1)
    }

    func setGraphDelegates() {
        graph.collectionGraphCellDelegate = self
        graph.collectionGraphLabelsDelegate = self
        graph.collectionGraphYDividerLineDelegate = self
    }

    func fetchGraphData() {

        let parser = TotalMilesRanParser()

        let service = DataService(parser: parser)

        service.fetchData(fromFile: "MilesPerDayData") { (data) in
            self.graph.graphData = data

            // each set of data has the same amount of data points so we'll just use the count from the first set
            self.graph.xSteps = data[0].count

            // Adjusts the width of the graph.  The Cells are spaced out depending on this size
            self.graph.graphContentWidth = 400

        }

    }

    // MARK: - Graph Delegates

    // CollectionGraphCellDelegate

    func collectionGraph(cell: UICollectionViewCell, forData data: GraphDatum, atSection section: Int) {

        if let peopleCell = cell as? PeopleCollectionViewCell {

            if let data = data as? TotalMilesRanDatum {

                let imageName = data.imageName
                peopleCell.image = UIImage(named: imageName) ?? UIImage()
            }
        }

        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = colorForSection(section: section).cgColor
        cell.layer.cornerRadius = 3
    }

    func collectionGraph(sizeForGraphCellWithData data: GraphDatum, inSection section: Int) -> CGSize {
        return CGSize(width: 30, height: 30)
    }

    // CollectionGraphLabelsDelegate

    func collectionGraph(textForXLabelWithCurrentText currentText: String, inSection section: Int) -> String {

        if let totalMilesData = graph.graphData?[0] as? [TotalMilesRanDatum] {
            let personName = totalMilesData[section].name

            return personName
        }

        return currentText
    }

    // CollectionGraphYDividerLineDelegate

    func collectionGraph(yDividerLine: CAShapeLayer) {
        yDividerLine.lineDashPattern = [1, 10]

        yDividerLine.lineWidth = 4
    }

}
