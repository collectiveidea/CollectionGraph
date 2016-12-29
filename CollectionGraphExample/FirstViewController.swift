//
//  FirstViewController.swift
//  CollectionGraphExample
//
//  Created by Chris Rittersdorf on 9/23/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit
import CollectionGraph

class FirstViewController: UIViewController, CollectionGraphViewDelegate, CollectionGraphCellDelegate, CollectionGraphBarDelegate, CollectionGraphLineDelegate, CollectionGraphLineFillDelegate, CollectionGraphLabelsDelegate {

    @IBOutlet weak var graph: CollectionGraphView!

    override func viewDidLoad() {
        super.viewDidLoad()

        graph.collectionGraphViewDelegate = self
        graph.collectionGraphCellDelegate = self
        graph.collectionGraphBarDelegate = self
        graph.collectionGraphLineDelegate = self
        graph.collectionGraphLineFillDelegate = self
        graph.collectionGraphLabelsDelegate = self

        // Adjusts the width of the graph.  The Cells are spaced out depending on this size
        // graph.graphContentWidth = 400

        // Change the Font of the X and Y labels
        // graph.fontName = "chalkduster"

        graph.ySideBarView = SideBarReusableView()

        // Simulate fetch delay from server
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.graph.graphData = Parser.parseExampleData(data: ExampleDataFromServer().json)
            self.graph.graphContentWidth = 400

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
        cell.backgroundColor = UIColor.darkText
        cell.layer.cornerRadius = cell.frame.width / 2
    }

    func collectionGraph(sizeForGraphCellWithData data: GraphDatum, inSection section: Int) -> CGSize {
        return CGSize(width: 8, height: 8)
    }

    // CollectionGraphBarDelegate

    func collectionGraph(barView: UICollectionReusableView, withData data: GraphDatum, inSection section: Int) {
        barView.backgroundColor = UIColor.lightGray
    }

    func collectionGraph(widthForBarViewWithData data: GraphDatum, inSection section: Int) -> CGFloat {
        return CGFloat(2)
    }

    // CollectionGraphLineDelegate

    func collectionGraph(connectorLine: GraphLineShapeLayer, withData data: GraphDatum, inSection section: Int) {
        connectorLine.lineWidth = 2
        connectorLine.lineDashPattern = [4, 2]
        // graphLine.straightLines = true
        // graphLine.lineCap = kCALineCapRound
        connectorLine.strokeColor = UIColor.darkGray.cgColor
    }

    // CollectionGraphLineFillDelegate

    func collectionGraph(fillColorForGraphSectionWithData data: GraphDatum, inSection section: Int) -> UIColor {
        return UIColor.red
    }

    // CollectionGraphLabelsDelegate

    func collectionGraph(textForXLabelWithCurrentText currentText: String, inSection section: Int) -> String {
        return "•"
        //return currentText
    }

}
