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
        // Do any additional setup after loading the view, typically from a nib.

        var layoutConfig = GraphLayoutConfig()
        layoutConfig.graphWidth = 400

        let layout = LineGraphLayout(config: layoutConfig)

        graph.layout = layout

        let cell = MyGraphCell()

        graph.graphCell = cell

        graph.graphData = Parser.parseExampleData(data: ExampleDataFromServer().json)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
