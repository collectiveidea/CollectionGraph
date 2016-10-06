//
//  GraphLayout.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

public class GraphLayout: UICollectionViewLayout {

    @IBInspectable var xSteps: Int = 2
    @IBInspectable var ySteps: Int = 6

    @IBInspectable var cellSize: CGSize = CGSize(width: 3.0, height: 3.0)
    
    @IBInspectable var cellSpacing: CGFloat = 20.0
    
    internal var graphData: GraphData?

    internal var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    override public func prepare() {
        
        if let collectionView = collectionView, let graphData = graphData {
            
            var tempAttributes = [UICollectionViewLayoutAttributes]()
            
            for sectionNumber in 0 ..< collectionView.numberOfSections {
                
                for itemNumber in 0 ..< collectionView.numberOfItems(inSection: sectionNumber) {
                    
                    let indexPath = IndexPath(item: itemNumber, section: sectionNumber)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    
                    let frame = CGRect(x: itemNumber * cellSpacing, y: yGraphPosition(points[sectionNumber][itemNumber].y) - cellSize.height / 2, width: cellSize.width, height: cellSize.height)
                    
                    attributes.frame = frame
                    
                    tempAttributes += [attributes]
                }
            }
            
            for number in 0 ..< ySteps {
                
                let indexPath = NSIndexPath(forItem: number, inSection: 0)
                
                let supplementaryAttribute = layoutAttributesForSupplementaryViewOfKind(String(YDividerLineView), atIndexPath: indexPath)
                
                if let supplementaryAttribute = supplementaryAttribute {
                    tempAttributes += [supplementaryAttribute]
                }
            }
            
            for number in 0...numberOfXDividerLines {
                
                let indexPath = NSIndexPath(forItem: number, inSection: 0)
                
                let supplementaryAttribute = layoutAttributesForSupplementaryViewOfKind(String(XDataView), atIndexPath: indexPath)
                
                if let supplementaryAttribute = supplementaryAttribute {
                    tempAttributes += [supplementaryAttribute]
                }
            }
            
            layoutAttributes = tempAttributes
        }
    }
    
    //MARK: - Helpers
    
    func calculateTotalYDistance() {
        
        var yVals = [CGFloat]()
        
        let data = graphData.flatMap { array in
            
        }
        
        
        for point in points {
            yVals += point.map { return $0.y }
        }
        
        let maxY = yVals.maxElement() ?? 0
        
        let remainder = maxY % CGFloat(ySteps)
        if remainder == 0 {
            yDelta = maxY
        } else {
            yDelta = maxY - remainder + CGFloat(ySteps)
        }
    }
    
    func yGraphPosition(val: CGFloat) -> CGFloat {
        
        if let collectionView = collectionView {
            let delta = collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom
            return delta - (delta * (val / yDelta))
        }
        
        return 0
    }


}
