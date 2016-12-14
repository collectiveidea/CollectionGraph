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
protocol CollectionGraphBarDelegate: class {

    func collectionGraph(
      barView: UICollectionReusableView,
      withData data: GraphDatum,
      inSection section: Int
      )

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
collectionGraph.collectionGraphBarDelegate = self
```
```swift
func collectionGraph(barView: UICollectionReusableView, withData data: GraphDatum, inSection section: Int) {
        barView.backgroundColor = UIColor.lightGray
    }
```

### Line Graph Connector Lines

Used for line graphs.  These are the lines that connect the `graphCells`.  Can be used with bar graphs as well.


///////////////////
Example Image of Line graphCells
///////////////////

#### Customizing a Connector Line with Delegate Callbacks
To display connector lines, you need to use a the delegate callback and set the line's properties.

```swift
protocol CollectionGraphLineDelegate: class {

    func collectionGraph(
      connectorLine: GraphLineShapeLayer,
      withData data: GraphDatum,
      inSection section: Int)
}
```

The `connectorLine` property provides a `GraphLineShapeLayer` which is a subclass of `CAShapeLayer`, and provides an additional property of `straightLines`.

```swift
class GraphLineShapeLayer: CAShapeLayer {
    public var straightLines: Bool = false
}
```

You can set all the visual properties of a CAShapeLayer to achieve the look you want.

Example properties:
* lineWidth
* straightLines
* lineDashPattern
* strokeColor

#### Example usage:
```swift
collectionGraph.collectionGraphLineDelegate = self
```
```swift
func collectionGraph(connectorLine: GraphLineShapeLayer, withData data: GraphDatum, inSection section: Int) {
        connectorLine.lineWidth = 2
        connectorLine.lineDashPattern = [4, 2]
        connectorLine.straightLines = true
        connectorLine.lineCap = kCALineCapRound
        connectorLine.strokeColor = UIColor.darkGray.cgColor
    }
```

### X Labels
To change the text displayed along the X axis, use `CollectionGraphLabelsDelegate`

```swift
public protocol CollectionGraphLabelsDelegate: class {

    func collectionGraph(
      textForXLabelWithCurrentText currentText: String,
      inSection section: Int
      ) -> String
}
```

#### Example usage:

```swift
collectionGraph.collectionGraphLabelsDelegate = self
```
```swift
func collectionGraph(textForXLabelWithCurrentText currentText: String, inSection section: Int) -> String {
        return "•"
    }
```

## Settable Properties

### Graph width and Insets
Width:<br>
By default the graphCells are plotted within the width of the CollectionGraph.<br>
By setting `graphContentWidth` you can extend the content width to allow scrolling.
```swift
var graphContentWidth: CGFloat
```

Insets:<br>
Adjust space along the edges of the CollectionGraph.<br>
The left and bottom space is used to layout the labels.
```swift
 var topInset: CGFloat

 var leftInset: CGFloat

 var bottomInset: CGFloat

 var rightInset: CGFloat
```
### Side Bar View
A view that lies behind the y axis labels and above the plotted graph.  Useful for covering the graph when it scrolls behind the y labels.
```swift
var ySideBarView: UICollectionReusableView?
```
**Note!**
 You need to provide a subclass of UICollectionReusableView and override `init(frame: CGRect)`.
 Inside the init block is where you set your customizations

 Initializiing a UICollectionReusableView() and then settings its background color will not work.

#### Example:
```swift
class MySideBarClass: UICollectionReusableView {

  override init(frame: CGRect) {
     super.init(frame: frame)
     backgroundColor = UIColor.red
  }

}
```   


### Y Divider Lines


x steps
y steps
colors
font
font size
label callback
