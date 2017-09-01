//
//  GraphLineReusableView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 6/12/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

internal class GraphLineLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var firstPoint: CGPoint = CGPoint.zero
    var secondPoint: CGPoint = CGPoint.zero
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone)
        if let copy = copy as? GraphLineLayoutAttributes {
            copy.firstPoint = firstPoint
            copy.secondPoint = secondPoint
        }
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? GraphLineLayoutAttributes {
            if attributes.firstPoint == firstPoint && attributes.secondPoint == secondPoint {
                return super.isEqual(object)
            }
        }
        return false
    }
}

open class GraphLineReusableView: UICollectionReusableView {
    
    public let line = CAShapeLayer()
    
    var firstPoint = CGPoint.zero
    var secondPoint = CGPoint.zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        line.strokeColor = UIColor.black.cgColor
        
        layer.addSublayer(line)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? GraphLineLayoutAttributes {
            self.firstPoint = attributes.firstPoint
            self.secondPoint = attributes.secondPoint
        }
    }
    
    func connectingLine() -> UIBezierPath? {
        
        let path = UIBezierPath()
        
//        var startingPoint = firstPoint//CGPoint(x: bounds.origin.x, y: bounds.origin.y)
//        var endingPoint = secondPoint//CGPoint(x: bounds.width, y: bounds.height)
        
//        if startsAtTop == false {
//            startingPoint = CGPoint(x: bounds.origin.x, y: bounds.height)
//            endingPoint = CGPoint(x: bounds.width, y: bounds.origin.y)
//        }
        
        
        
//        print("points \(startingPoint), \(endingPoint)")
        
        path.move(to: firstPoint)
        
//        if line.straightLines {
            path.addLine(to: secondPoint)
//        }
//        else {
//            let cp1 = CGPoint(x: (startingPoint.x + endingPoint.x) / 2, y: startingPoint.y)
//            let cp2 = CGPoint(x: (startingPoint.x + endingPoint.x) / 2, y: endingPoint.y)
//            path.addCurve(to: endingPoint, controlPoint1: cp1, controlPoint2: cp2)
//        }
        
        return path
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        line.path = connectingLine()?.cgPath
    }
        
}
