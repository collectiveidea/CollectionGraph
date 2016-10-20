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

        graph.layout = LineGraphLayout()
        graph.layout?.graphWidth = 400

        graph.graphData = Parser.parseExampleData(data: ExampleDataFromServer().json)

        graph.setCellProperties { (cell, graphData) in
            cell.backgroundColor = UIColor.lightGray
        }

        graph.setCellLayout{ (graphData) -> (GraphCellLayoutAttribues) in
            return GraphCellLayoutAttribues(size: CGSize(width: 10, height: 10))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
