//
//  LineConnectorView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/13/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

public class GraphLineShapeLayer: CAShapeLayer {
    public var straightLines: Bool = false
}

class LineConnectorView: UICollectionReusableView {

    var line: GraphLineShapeLayer = GraphLineShapeLayer()
    var lineStartsAtTop = true
    var lineWidth: CGFloat = 1

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

        layer.addSublayer(line)
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? LineConnectorAttributes {
            self.lineStartsAtTop = attributes.lineStartsAtTop
            setNeedsLayout()
        }
    }

    func drawLine() {

        var start = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
        var end = CGPoint(x: self.bounds.maxX, y: self.bounds.minY)

        if self.lineStartsAtTop {
            start.y = self.bounds.minY
            end.y = self.bounds.maxY
        }

        let path = UIBezierPath()
        path.move(to: start)
        path.lineWidth = 50

        if line.straightLines {
            path.addLine(to: end)
        } else {
            let cp1 = CGPoint(x: (start.x + end.x) / 2, y: start.y)
            let cp2 = CGPoint(x: (start.x + end.x) / 2, y: end.y)
            path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        }

        self.line.path = path.cgPath
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        drawLine()
    }

}
