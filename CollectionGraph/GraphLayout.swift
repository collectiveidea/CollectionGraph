//
//  GraphLayout.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

public class GraphLayout: UICollectionViewLayout {

    @IBInspectable var xSteps: Int = 2
    @IBInspectable var ySteps: Int = 6

    @IBInspectable var cellSize: CGSize = CGSize(width: 3.0, height: 3.0)

    internal var layoutAttributes = [UICollectionViewLayoutAttributes]()
}
