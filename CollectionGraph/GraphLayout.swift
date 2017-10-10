//
//  GraphLayout.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 5/23/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

/*
 on frame change
 loop thru number of items in index,
 request point for index
 see if point is in rect
 if yes
    create attributes
    set attributes
    cache attributes
 if no
    return nil
 
 
 =====
 issue is that every frame change we loop over the data and check if it intersects the rect
 */

import UIKit

public extension String {
    static let graphLayoutElementKindLine = "graphLayoutElementKindLine"
    static let graphLayoutElementKindXAxisView = "graphLayoutElementKindXAxisView"
}

public class GraphLayout: UICollectionViewLayout {
    
    internal var cellLayoutAttributesModel: CellLayoutAttributesModel? {
        didSet {
            if let cellLayoutAttributesModel = cellLayoutAttributesModel {
                attributeModels += [cellLayoutAttributesModel]
            }
        }
    }
    
    internal var graphLineLayoutAttributesModel: GraphLineLayoutAttributesModel? {
        didSet {
            if let graphLineLayoutAttributesModel = graphLineLayoutAttributesModel {
                attributeModels += [graphLineLayoutAttributesModel]
            }
        }
    }
    
    internal var xAxisLayoutAttributesModel: XAxisLayoutAttributesModel? {
        didSet {
            if let xAxisLayoutAttributesModel = xAxisLayoutAttributesModel {
                attributeModels += [xAxisLayoutAttributesModel]
            }
        }
    }
    
    var attributeModels = [LayoutAttributesModel]()
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributes = [UICollectionViewLayoutAttributes]()
        
        attributeModels.forEach {
            
            let att = $0.attributes(in: rect)
            
            attributes += att
        }
        return attributes
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cellLayoutAttributesModel?.attributesForItem(at: indexPath)
    }
    
    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        switch elementKind {
        
        case .graphLayoutElementKindLine:
            return graphLineLayoutAttributesModel?.attributesForItem(at: indexPath)
        case .graphLayoutElementKindXAxisView:
            return xAxisLayoutAttributesModel?.attributesForItem(at: indexPath)
        default:
            return nil
        }
    }
    
    override public var collectionViewContentSize: CGSize {
        
        if let collectionView = collectionView {
            
            let decorator = GraphLayoutDecorator(collectionView: collectionView)
            
            let distanceBetweenXSteps = decorator.distanceOfXSteps()
            
            let numberOfXSteps: CGFloat = CGFloat(decorator.numberOfXSteps())
            
            // TODO: Should be a delegate call incase there are numerous sections with different cell sizes at the first index.  For now we will just grab the first.
            let cellSize = decorator.sizeOfCell(at: IndexPath(item: 0, section: 0))
            
            // expand the width of the graph by the section insets to keep the distanceBetweenXSteps as specified
            let widthPadding = collectionView.contentInset.left + collectionView.contentInset.right + cellSize.width //full width used for half inset on right and left.  Should use a delegate call in case the size of the last item is larger.
            
            let heightOfCollectionView = collectionView.frame.height
            
            let heightPadding = collectionView.contentInset.top + collectionView.contentInset.bottom
            
            let width = distanceBetweenXSteps * numberOfXSteps - widthPadding
            let height = heightOfCollectionView - heightPadding
            
            return CGSize(width: width, height: height)
        }
        return CGSize.zero
    }
    
}
