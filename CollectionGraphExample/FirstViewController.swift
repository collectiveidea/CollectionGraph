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

        graph.layout = GraphLayout()
        graph.layout?.graphWidth = 400

        let cell = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        cell.contentView.backgroundColor = UIColor.red

        graph.graphCell = cell

        graph.graphData = GraphData(data: [[CGPoint(x: 1, y: 1), CGPoint(x: 2, y: 2), CGPoint(x: 4, y: 5)]])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
