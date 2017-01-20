//
//  GraphDelegates.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 12/13/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

public protocol CollectionGraphCellDelegate: class {
    /**
     Returns the graphCell and corresponding GraphDatum.
     
     Use this to set any properties on the graphCell like color, layer properties, or any custom visual properties from your subclass.
     
     - parameter cell: The corresponding graphCell
     - parameter data: The corresponding GraphDatum
     - parameter section: The section number of [GraphDatum]
     */
    func collectionGraph(cell: UICollectionViewCell, forData data: GraphDatum, atSection section: Int)

    /**
     Set the size of the graphCell
     
     - parameter data: The corresponding GraphDatum
     - parameter section: The section number of [GraphDatum]
     */
    func collectionGraph(sizeForGraphCellWithData data: GraphDatum, inSection section: Int) -> CGSize
}

public protocol CollectionGraphBarDelegate: class {
    /**
     Returns the barCell and corresponding GraphDatum.
     
     Use this to set any properties on the barCell like color, layer properties, or any custom visual properties from your subclass.
     
     - parameter barView: The corresponding barView
     - parameter data: The corresponding GraphDatum
     - parameter section: The section number of [GraphDatum]
     */
    func collectionGraph(barView: UICollectionReusableView, withData data: GraphDatum, atItem item: Int, inSection section: Int)

    /**
     Set the width of the barCell with corresponding GraphDatum in Section
     
     - parameter data: The corresponding GraphDatum
     - parameter section: The section number of [GraphDatum]
     */
    func collectionGraph(widthForBarViewWithData data: GraphDatum, atItem item: Int, inSection section: Int) -> CGFloat
}

public protocol CollectionGraphLineDelegate: class {
    /**
     Returns the Connector Lines and corresponding GraphDatum.
     
     Use this to set any properties on the line like color, dot pattern, cap, or any custom visual properties from your subclass.
     
     - parameter connectorLine: GraphLineShapeLayer is a CAShapeLayer subclass with an extra straightLines Bool you can set.  The default is false.
     
     - parameter data: the corresponding GraphDatum
     - parameter section: The section number in [[GraphDatum]]
     */
    func collectionGraph(connectorLine: GraphLineShapeLayer, withData data: GraphDatum, inSection section: Int)
}

public protocol CollectionGraphLineFillDelegate: class {
    /**
     Set the color of the fill below the graph line
     
     - parameter data: the corresponding GraphDatum
     - parameter section: The section number in [[GraphDatum]]
    */
    func collectionGraph(fillColorForGraphSectionWithData data: GraphDatum, inSection section: Int) -> UIColor
}

public protocol CollectionGraphLabelsDelegate: class {
    /**
     Set the text of label along the x axis
     
     ## Tip:
     Useful for converting Dates that were converted to Ints back to Dates
     
     - parameter currentString: The labels current string
     - parameter section: The labels current section number
     */
    func collectionGraph(textForXLabelWithCurrentText currentText: String, item: Int) -> String
}

public protocol CollectionGraphViewDelegate: class {
    /**
     Returns the visible IndexPaths and Sections as Sets<> when scrolling
     
     - parameter indexPaths: Set<IndexPath> of visible GraphDatum
     - parameter sections: Set<Int> of visible sections of [GraphDatum]
     */
    func collectionGraph(updatedVisibleIndexPaths indexPaths: Set<IndexPath>, sections: Set<Int>)
}

public protocol CollectionGraphYDividerLineDelegate: class {
    /**
     Returns the Y Divider Lines.
     
     Use this to set any properties on the line like color, dot pattern, cap.
     
     - parameter yDividerLine: CAShapeLayer
     */
    func collectionGraph(yDividerLine: CAShapeLayer)
}
