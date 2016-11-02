//
//  XLabelView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/14/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class XLabelView: UICollectionReusableView {

    var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        label.font = UIFont.systemFont(ofSize: 8)
        label.textAlignment = .center
        label.textColor = UIColor.white
        addSubview(label)
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {

        if let attributes = layoutAttributes as? XLabelViewAttributes {
            label.text = attributes.text
            label.sizeToFit()
            label.frame = attributes.bounds
        }
    }

}
