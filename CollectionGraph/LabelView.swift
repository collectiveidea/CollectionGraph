//
//  XLabelView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/14/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class LabelView: UICollectionReusableView {

    var label = UILabel()
    var textColor: UIColor = UIColor.darkText

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
        label.textColor = textColor
        label.text = ""
        addSubview(label)
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {

        if let attributes = layoutAttributes as? XLabelViewAttributes {
            label.sizeToFit()
            label.frame = attributes.bounds
        }
    }

}
