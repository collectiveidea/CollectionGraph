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

    @IBOutlet weak var graphCollectionView: UICollectionView!

    @IBOutlet public var layout: UICollectionViewLayout? {
        didSet {
            if let layout = layout {
                print("* Set Layout *")

                graphCollectionView.collectionViewLayout = layout
            }
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

        setupXib()

        self.type = type
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }

    func setupXib() {
        let bundle = Bundle(for: type(of: self))

        let nib = UINib(nibName: "CollectionGraph", bundle: bundle)

        let nibView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView

        nibView?.frame = bounds

        if let nibView = nibView {
            addSubview(nibView)
        }
    }

}



// CollectionGraphView
// |
// |+ UICollectionView
// |+ UICollectionViewDelegate
