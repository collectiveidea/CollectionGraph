//
//  YDividerLineView.swift
//  Graph
//
//  Created by Ben Lambert on 9/13/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

class YDividerLineView: UICollectionReusableView {

    var line: CAShapeLayer = CAShapeLayer()
    var lineWidth: CGFloat = 1
    var lineColor: UIColor = UIColor.lightGray
    var textColor: UIColor = UIColor.darkText
    var inset: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        line.fillColor = UIColor.clear.cgColor
        line.strokeColor = lineColor.cgColor
        line.lineDashPattern = [1.0, 4.0]
        line.lineWidth = lineWidth
        layer.addSublayer(line)
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? YDividerLayoutAttributes {
            inset = attributes.inset
        }
    }

    func drawLine() {
        let start = CGPoint(x: self.bounds.minX + inset, y: self.bounds.minY)
        let end = CGPoint(x: self.bounds.maxX, y: self.bounds.minY)

        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        self.line.path = path.cgPath
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        drawLine()
    }

}
