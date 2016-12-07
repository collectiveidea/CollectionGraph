//
//  FirstViewController.swift
//  CollectionGraphExample
//
//  Created by Chris Rittersdorf on 9/23/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit
import CollectionGraph

class FirstViewController: UIViewController {

    @IBOutlet weak var graph: CollectionGraphView!

    override func viewDidLoad() {
        super.viewDidLoad()

        graph.graphContentWidth = 400
        
//        graph.fontName = "chalkduster"

        graph.setCellProperties { (cell, graphDatum, section) in
            cell.backgroundColor = UIColor.darkText
            cell.layer.cornerRadius = cell.frame.width / 2
        }

        graph.setCellSize { (graphDatum) -> (CGSize) in
            return CGSize(width: 8, height: 8)
        }

        graph.setBarViewProperties { (cell, graphDatum, section) in
            cell.backgroundColor = UIColor.lightGray
        }

        graph.setBarViewWidth { (graphDatum) -> (CGFloat) in
            return CGFloat(2)
        }

        graph.setLineViewProperties { (graphLine, graphDatum, section) -> () in
            graphLine.lineWidth = 2
            graphLine.lineDashPattern = [4, 2]
//            graphLine.straightLines = true
//            graphLine.lineCap = kCALineCapRound
            graphLine.strokeColor = UIColor.darkGray.cgColor
        }

//        graph.setXLabelText { (graphDatum) -> (String) in
//            return "•"
//        }

        // Simulate fetch delay from server
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.graph.graphData = Parser.parseExampleData(data: ExampleDataFromServer().json)

//            self.graph.scrollToDataPoint(graphDatum: self.graph.graphData![0].last!, withAnimation: true, andScrollPosition: .centeredHorizontally)

            self.graph.contentOffset = CGPoint(x: 30, y: self.graph.contentOffset.y)
        })

        graph.didUpdateVisibleIndices { (indexPaths, sections) in
            indexPaths.forEach {
                let data = self.graph.graphData?[$0.section][$0.item]
                print("Data: \(data)")
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
