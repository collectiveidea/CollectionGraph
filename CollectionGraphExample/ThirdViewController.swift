//
//  ThirdViewController.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 1/19/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import UIKit
import CollectionGraph

class ThirdViewController: UIViewController, CollectionGraphCellDelegate, CollectionGraphLabelsDelegate, CollectionGraphBarDelegate, CollectionGraphYDividerLineDelegate, ColorHelpers {

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

        // Provide a custom bar cell that has a gradient layer
        graph.barView = BarReusableView()

        graph.yDividerLineColor = UIColor(red: 112.0 / 255.0, green: 110.0 / 255.0, blue: 171.0 / 255.0, alpha: 1)
    }

    func setGraphDelegates() {
        graph.collectionGraphCellDelegate = self
        graph.collectionGraphLabelsDelegate = self
        graph.collectionGraphBarDelegate = self
        graph.collectionGraphYDividerLineDelegate = self
    }

    func fetchGraphData() {

        let parser = TotalMilesRanParser()

        let service = DataService(parser: parser)

        service.fetchData(fromFile: "TotalMilesRan") { (data) in
            self.graph.graphData = data

            // each set of data has the same amount of data points so we'll just use the count from the first set
            self.graph.xSteps = data[0].count

            // Adjusts the width of the graph.  The Cells are spaced out depending on this size
            let spacing = 80
            self.graph.graphContentWidth = CGFloat(self.graph.xSteps) * CGFloat(spacing)
        }

    }

    // MARK: - Graph Delegates

    // CollectionGraphCellDelegate

    func collectionGraph(cell: UICollectionViewCell, forData data: GraphDatum, atIndexPath indexPath: IndexPath) {

        if let peopleCell = cell as? PeopleCollectionViewCell {

            if let data = data as? TotalMilesRanDatum {

                let imageName = data.imageName
                peopleCell.image = UIImage(named: imageName) ?? UIImage(named: "DefaultUser")!
            }
        }

        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 2

        let colorNumber = indexPath.item % 4

        cell.layer.borderColor = colorForSection(section: colorNumber).cgColor
        cell.layer.cornerRadius = 5
    }

    func collectionGraph(sizeForGraphCellWithData data: GraphDatum, atIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }

    // CollectionGraphLabelsDelegate

    func collectionGraph(textForXLabelWithCurrentText currentText: String, item: Int) -> String {

        if let totalMilesData = graph.graphData?[0] as? [TotalMilesRanDatum] {
            let personName = totalMilesData[item].name

            return personName
        }

        return currentText
    }

    // CollectionGraphBarDelegate

    func collectionGraph(widthForBarViewWithData data: GraphDatum, atIndexPath indexPath: IndexPath) -> CGFloat {
        return 7
    }

    func collectionGraph(barView: UICollectionReusableView, withData data: GraphDatum, atIndexPath indexPath: IndexPath) {
        if let barView = barView as? BarReusableView {

            let colorNumber = indexPath.item % 4

            let color1 = colorForSection(section: colorNumber).cgColor
            let color2 = UIColor(red: 112.0 / 255.0, green: 110.0 / 255.0, blue: 171.0 / 255.0, alpha: 1).cgColor
            barView.colors = [color1, color2]
        }
    }

    // CollectionGraphYDividerLineDelegate

    func collectionGraph(yDividerLine: CAShapeLayer, atItem item: Int) {

        let length = NSNumber(integerLiteral: item)

        yDividerLine.lineDashPattern = [length, 8]
    }

}
