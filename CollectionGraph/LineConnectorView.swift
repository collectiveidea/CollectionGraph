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

    public override var strokeColor: CGColor? {
        didSet {
            removeAllAnimations()
            CATransaction.begin()
            CATransaction.setDisableActions(true)

            super.strokeColor = strokeColor

            CATransaction.commit()
        }
    }
}

class LineConnectorView: UICollectionReusableView {

    var line: GraphLineShapeLayer = GraphLineShapeLayer()

    var fillShape = CAShapeLayer()

    var points:(first: CGPoint, second: CGPoint)?

    var lineWidth: CGFloat = 1

    var fillColor: UIColor?

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

        layer.addSublayer(fillShape)
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? LineConnectorAttributes {
            self.points = attributes.points
            setNeedsLayout()
        }
    }

    func drawLine() {
        if let bezPath = connectingLine() {
            self.line.path = bezPath.cgPath
        }
    }

    func connectingLine() -> UIBezierPath? {
        if let points = points {
            let path = UIBezierPath()

            let startingPoint = CGPoint(x: 0, y: points.first.y)
            let endingPoint = CGPoint(x: bounds.width, y: points.second.y)

            path.move(to: startingPoint)

            if line.straightLines {
                path.addLine(to: endingPoint)
            } else {
                let cp1 = CGPoint(x: (startingPoint.x + endingPoint.x) / 2, y: startingPoint.y)
                let cp2 = CGPoint(x: (startingPoint.x + endingPoint.x) / 2, y: endingPoint.y)
                path.addCurve(to: endingPoint, controlPoint1: cp1, controlPoint2: cp2)
            }

            return path
        }
        return nil
    }

    func fillLineWithColor() {
        if let fillColor = fillColor {

            CATransaction.begin()
            CATransaction.setDisableActions(true)

            var path = UIBezierPath()

            if let bezPath = connectingLine() {
                path = bezPath

                let bottomRight = CGPoint(x: bounds.width, y: bounds.height)
                let bottomLeft = CGPoint(x: 0, y: bounds.height)

                path.addLine(to: bottomRight)
                path.addLine(to: bottomLeft)
            }

            fillShape.path = path.cgPath

            fillShape.fillColor = fillColor.cgColor

            CATransaction.commit()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        drawLine()

        fillLineWithColor()
    }

}
