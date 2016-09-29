//
//  LineGraphLayout.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

@IBDesignable
public class LineGraphLayout: GraphLayout {

    var colors = [UIColor.gray]

    @IBInspectable var lineThickness: CGFloat = 1

    @IBInspectable var straightLines = false
}
