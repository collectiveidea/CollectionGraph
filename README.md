# CollectionGraph ![Travis CI](https://api.travis-ci.org/collectiveidea/CollectionGraph.svg)

A flexible and customizable scatter, bar, and line graphing tool for iOS. Backed by UICollectionViews.

## Features
* Plot numerous collections of data on one graph.
* Supply custom views for data points, and other elements.
* Callbacks to customize specific elements.
* Layout using storyboards (However, `IBDesignables` do not carry over in linked frameworks)

## Installation

### Carthage
To integrate CollectionGraph into your Xcode project using Carthage, specify it in your `Cartfile`:
<br><br>
```
github "collectiveidea/CollectionGraph"
```

## Usage
* Check out the CollectionGraphExample target in the project to see some examples

### Plotting Points

///////////////
example image
//////////////

To plot a graph of simple points, assign the CollectionGraph's `graphData` property.

```Swift
import CollectionGraph

var graphData: [[GraphDatum]]?
```

Each array of `[GraphDatum]` represents a new "section" in the graph.  Each section should represent a different set of data.

For example:<br>

```swift
let data = [[losAngelesGraphData()], [newYorkGraphData()], [grandRapidsGraphData()]]
```
Three different sets of points (each city) will be plotted on the same graph.

`GraphDatum` is a protocol that requires a CGPoint.
You can add other properties you may want to surface during the Callbacks to better identify the data.

##### Example
```swift
struct Data: GraphDatum {
    var point: CGPoint
    var id: String
}
```
## Customization

### Graph Cells

#### Custom graphCells
If you want a custom graphCell instead of the default square, you can set the `graphCell` property.
```swift
var graphCell: UICollectionViewCell?
```
Using the provided Delegate Callbacks, you can set your `graphCell` properties for specific `graphData` points

This is great for setting images or labels that change depending on the data.

///////////////
example image of Keg Users
//////////////

#### Cell Delegate Callbacks

```swift
protocol CollectionGraphCellDelegate: class {

  func collectionGraph(
    cell: UICollectionViewCell,
    forData data: GraphDatum,
    atSection section: Int
    )

  func collectionGraph(
    sizeForGraphCellWithData data: GraphDatum,
    inSection section: Int
    ) -> CGSize
}
```

1) Properties Callback - Set the visual treatment on a cell.<br>
`func collectionGraph(cell: UICollectionViewCell, forData data: GraphDatum, atSection section: Int)`

Example properties:
* backgroundColor
* layer.cornerRadius
* Any custom properties you added in a subclass
* etc...


##### Example usage:
```swift
collectionGraph.collectionGraphCellDelegate = self
```
```swift
collectionGraph.setCellProperties { (cell, graphDatum, section) in
            cell.backgroundColor = UIColor.red
            cell.layer.cornerRadius = cell.frame.width / 2

            // custom graphCell
            if let myCell = cell as? myCell {
              myCell.image = UIImage(named: "profilePic.png")
            }
        }
```

2) Size Callback

```swift
func collectionGraph(sizeForGraphCellWithData data: GraphDatum, inSection section: Int) -> CGSize {
    if section == 0 {
        return CGSize(width: 3, height: 3)
    }

    return CGSize(width: 8, height: 8)
}
```

### Bar Graph Views
Used for bar graphs.  These are the views that start at the bottom of the graph and extend to graphCell.  Can be used with line graphs as well.

#### Custom barViews

If you want a custom barView instead of the default view, you can the the `barView` property

```swift
var barView: UICollectionReusableView?
```
//////////////////
EXAMPLE Image OF BAR Graph
//////////////////

#### BarView Delegate Callbacks

```swift
public protocol CollectionGraphBarDelegate: class {
    /**
     Returns the barCell and corresponding GraphDatum.

     Use this to set any properties on the barCell like color, layer properties, or any custom visual properties from your subclass.

     - parameter barView: The corresponding barView
     - parameter data: The corresponding GraphDatum
     - parameter section: The section number of [GraphDatum]
     */
    func collectionGraph(
      barView: UICollectionReusableView,
      withData data: GraphDatum,
      inSection section: Int
      )

    /**
     Set the width of the barCell with corresponding GraphDatum in Section

     - parameter data: The corresponding GraphDatum
     - parameter section: The section number of [GraphDatum]
     */
    func collectionGraph(
      widthForBarViewWithData data: GraphDatum,
      inSection section: Int
      ) -> CGFloat
}
```

1) Propery Callback - Set the visual treatment on a bar view.<br>
`func collectionGraph(barView: UICollectionReusableView, withData data: GraphDatum, inSection section: Int)`

Example properties:
* backgroundColor
* Any custom properties you added in a subclass
* etc...


##### Example usage:
```swift
func collectionGraph(barView: UICollectionReusableView, withData data: GraphDatum, inSection section: Int) {
        barView.backgroundColor = UIColor.lightGray
    }
```

### Line Graph Lines

### Graph width and Insets

### Y Divider Lines

### X & Y Labels
x steps
y steps
colors
font
font size
label callback
