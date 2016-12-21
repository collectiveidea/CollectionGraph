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
    var label: UILabel = UILabel()

    var attributes: LineConnectorAttributes!

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
        
        backgroundColor = UIColor.yellow.withAlphaComponent(0.01)
        let randoRed = CGFloat(arc4random_uniform(255))
        let randoBlue = CGFloat(arc4random_uniform(255))
        let randoGreen = CGFloat(arc4random_uniform(255))
        layer.borderColor = UIColor(red: randoRed / 255.0, green: randoGreen / 255.0, blue: randoBlue / 255.0, alpha: 1).withAlphaComponent(0.3).cgColor
        layer.borderWidth = 1
        
        label.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        label.font = UIFont(name: "Helvetica", size: 8)
        label.textColor = UIColor.red
        //label.textAlignment = .center
        label.text = "----"
        addSubview(label)
        print("SETUP")
    }

//    override func prepareForReuse() {
//        super.prepareForReuse()
//        lineStartsAtTop = attributes.lineStartsAtTop
//        drawLine()
//        label.text? += "XXX"
//        
//    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? LineConnectorAttributes {
            self.attributes = attributes
            self.lineStartsAtTop = attributes.lineStartsAtTop
            label.text? = "8===D"
            setNeedsLayout()
//            layoutIfNeeded()
            
        }
    }

    func drawLine() {

        assert(self.lineStartsAtTop == attributes.lineStartsAtTop)

        var start = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
        var end = CGPoint(x: self.bounds.maxX, y: self.bounds.minY)
        label.text = "B"
        if self.lineStartsAtTop {
            start.y = self.bounds.minY
            end.y = self.bounds.maxY
            
            label.text = "Top"
        }

        assert(self.lineStartsAtTop == attributes.lineStartsAtTop)
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
