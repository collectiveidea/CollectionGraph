//
//  CollectionGraphView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/23/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

@IBDesignable
public class CollectionGraphView: UIView {

    @IBInspectable public var myColor: UIColor = UIColor.red {
        didSet {
            backgroundColor = myColor
        }
    }
}
