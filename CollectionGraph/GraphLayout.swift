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
    static let graphLayoutElementKindYAxisView = "graphLayoutElementKindYAxisView"
    static let graphLayoutElementKindHorrizontalDividersView = "graphLayoutElementKindHorrizontalDividersView"
    static let graphLayoutElementKindBarGraph = "graphLayoutElementKindBarGraph"
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
    
    internal var yAxisLayoutAttributesModel: YAxisLayoutAttributesModel? {
        didSet {
            if let yAxisLayoutAttributesModel = yAxisLayoutAttributesModel {
                attributeModels += [yAxisLayoutAttributesModel]
            }
        }
    }
    
    internal var horizontalLayoutAttributesModel: HorizontalLayoutAttributesModel? {
        didSet {
            if let horizontalLayoutAttributesModel = horizontalLayoutAttributesModel {
                attributeModels += [horizontalLayoutAttributesModel]
            }
        }
    }
    
    internal var barGraphLayoutAttributesModel: BarGraphLayoutAttributesModel? {
        didSet {
            if let barGraphLayoutAttributesModel = barGraphLayoutAttributesModel {
                attributeModels += [barGraphLayoutAttributesModel]
            }
        }
    }
    
    var attributeModels = [LayoutAttributesModel]()
    
    private var contentSizeCache = CGSize.zero
    
    public override func prepare() {
        clearCaches()
    }
    
    func clearCaches() {
        attributeModels.forEach {
            $0.cache.removeAll()
            $0.decorator.xMinMaxValuesCache = nil
            $0.decorator.yMinMaxValuesCache = nil
        }
        contentSizeCache = .zero
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return true
    }
    
    public override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        
        let context = super.invalidationContext(forBoundsChange: newBounds)
        
        if collectionView?.bounds.size == newBounds.size {
            // invalidate the y axis
            
            guard let visibleItems = collectionView?.indexPathsForVisibleSupplementaryElements(ofKind: .graphLayoutElementKindYAxisView) else { return context }
            
            context.invalidateSupplementaryElements(ofKind: .graphLayoutElementKindYAxisView, at: visibleItems)
            
        } else {
            
            clearCaches()
            
            invalidateLayout()
        }

        return context
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
        
        case .graphLayoutElementKindYAxisView:
            return yAxisLayoutAttributesModel?.attributesForItem(at: indexPath)
        
        case .graphLayoutElementKindHorrizontalDividersView:
            return horizontalLayoutAttributesModel?.attributesForItem(at: indexPath)
        
        case .graphLayoutElementKindBarGraph:
            return barGraphLayoutAttributesModel?.attributesForItem(at: indexPath)
        
        default:
            return nil
        }
    }
    
    override public var collectionViewContentSize: CGSize {
        
        if contentSizeCache != .zero {
            return contentSizeCache
        }
        
        if let collectionView = collectionView as? GraphCollectionView {
            
            let decorator = GraphLayoutDecorator(collectionView: collectionView)
            
            let distanceBetweenXSteps = decorator.distanceOfXSteps()
            
            let numberOfXSteps: CGFloat = CGFloat(decorator.numberOfXSteps())
            
            // TODO: Should be a delegate call incase there are numerous sections with different cell sizes at the first index.  For now we will just grab the first.
            let cellSize = decorator.sizeOfCell(at: IndexPath(item: 0, section: 0))
            
            let heightOfCollectionView = collectionView.frame.height
            
            let heightPadding = collectionView.contentInset.top + collectionView.contentInset.bottom
            
            let width = distanceBetweenXSteps * numberOfXSteps - distanceBetweenXSteps  + cellSize.width + decorator.paddingForYAttributes
            let height = heightOfCollectionView - heightPadding
            
            contentSizeCache = CGSize(width: width, height: height)
            
            return contentSizeCache
        }
        return CGSize.zero
    }
    
}
