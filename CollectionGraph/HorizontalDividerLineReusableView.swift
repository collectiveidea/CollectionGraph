//
//  DottedLineReusableView.swift
//  LotsOfDataGraph
//
//  Created by Ben Lambert on 10/11/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

open class HorizontalDividerLineReusableView: UICollectionReusableView {
    
    public let line: CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(line)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: frame.height / 2))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height / 2))
        
        line.path = path.cgPath
        
        line.lineWidth = 1
        line.lineDashPattern = [1, 3]
        line.strokeColor = UIColor.lightGray.cgColor
    }
    
    open override func layoutSubviews() {
        line.frame = bounds
    }
    
}
