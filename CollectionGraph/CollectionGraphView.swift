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

    public enum GraphType {
        case Dot, Line, Bar
    }

    var type: GraphType? {
        didSet {
            if let type = type {
                switch type {
                case .Dot:
                    // TODO: - update with Dot layout subclass
                    layout = UICollectionViewLayout()
                case .Line:
                    // TODO: - update with Line layout subclass
                    layout = UICollectionViewLayout()
                case .Bar:
                    // TODO: - update with Bar layout subclass
                    layout = UICollectionViewLayout()
                }
            }
        }
    }

    @IBOutlet public var layout: UICollectionViewLayout? {
        didSet {
            print("* Set Layout *")
        }
    }

    @IBInspectable public var myColor: UIColor = UIColor.red {
        didSet {
            backgroundColor = myColor
        }
    }

    // MARK: - View Lifecycle

    required public init(frame: CGRect, type: GraphType) {
        super.init(frame: frame)

        self.type = type
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}



// CollectionGraphView
// |
// |+ UICollectionView
// |+ UICollectionViewDelegate
