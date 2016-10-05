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

    @IBInspectable public var layout: GraphLayout? {
        didSet {
            if let layout = layout {
                self.graphCollectionView.collectionViewLayout = layout
            }
        }
    }

    @IBOutlet weak var graphCollectionView: UICollectionView!

    // MARK: - View Lifecycle

    required public init(frame: CGRect, layout: GraphLayout) {
        super.init(frame: frame)

        addCollectionView()

        self.layout = layout
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addCollectionView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addCollectionView()
    }

    func addCollectionView() {
        let xibView = XibLoader.viewFromXib(name: "GraphCollectionView", owner: self)

        xibView?.frame = bounds

        if let xibView = xibView {
            addSubview(xibView)
        }
    }

}
