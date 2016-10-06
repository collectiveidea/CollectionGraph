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

    @IBOutlet var layout: UICollectionViewLayout? {
        didSet {
            if let layout = layout {
                self.collectionView.collectionViewLayout = layout
            }
        }
    }

    var collectionView: UICollectionView!

    required public init(frame: CGRect, layout: UICollectionViewLayout) {
        super.init(frame: frame)

        self.layout = layout
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
