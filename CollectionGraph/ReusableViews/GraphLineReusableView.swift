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
    
    public var color = UIColor.black {
        didSet {
            line.strokeColor = color.cgColor
        }
    }
    
    public var straightLines = true
    
    let line = CAShapeLayer()
    
    var firstPoint = CGPoint.zero
    var secondPoint = CGPoint.zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        line.strokeColor = color.cgColor
        line.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(line)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? GraphLineLayoutAttributes {
            self.firstPoint = attributes.firstPoint
            self.secondPoint = attributes.secondPoint
            setNeedsLayout()
        }
    }
    
    func connectingLine() -> UIBezierPath? {
        
        let path = UIBezierPath()
        
        path.move(to: firstPoint)
        
        if straightLines {
            path.addLine(to: secondPoint)
        }
        else {
            let cp1 = CGPoint(x: (firstPoint.x + secondPoint.x) / 2, y: firstPoint.y)
            let cp2 = CGPoint(x: (firstPoint.x + secondPoint.x) / 2, y: secondPoint.y)
            path.addCurve(to: secondPoint, controlPoint1: cp1, controlPoint2: cp2)
        }
        
        return path
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        line.path = connectingLine()?.cgPath
    }
        
}