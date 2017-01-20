//
//  BarReusableView.swift
//  [i]Kegerator
//
//  Created by Ben Lambert on 12/21/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class BarReusableView: UICollectionReusableView {

    let gradient = CAGradientLayer()

    var colors = [CGColor]() {
        didSet {
            gradient.colors = colors
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear

        let topColor = UIColor(red: 251.0/255.0, green: 246.0/255.0, blue: 0.0/255.0, alpha: 1).cgColor
        let bottomColor = UIColor(red: 24.0/255.0, green: 193.0/255.0, blue: 215.0/255.0, alpha: 1).cgColor

        gradient.colors = [topColor, bottomColor]
        gradient.locations = [0.0, 1.0]

        gradient.frame = bounds

        layer.addSublayer(gradient)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        gradient.frame = bounds

        CATransaction.commit()
    }

}
