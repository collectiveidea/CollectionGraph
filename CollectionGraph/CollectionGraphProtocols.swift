
import Foundation

public protocol CollectionGraphDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, valueFor indexPath: IndexPath) -> (xValue: CGFloat, yValue: CGFloat)
    
}

public protocol CollectionGraphDelegateLayout: UICollectionViewDelegate {
    
    func graphCollectionView(_ graphCollectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    func minAndMaxYValuesIn(_ graphCollectionView: UICollectionView) -> (min: CGFloat, max: CGFloat)
    
    func numberOfYStepsIn(_ graphCollectionView: UICollectionView) -> Int
    
    func minAndMaxXValuesIn(_ graphCollectionView: UICollectionView) -> (min: CGFloat, max: CGFloat)
    
    func numberOfXStepsIn(_ graphCollectionView: UICollectionView) -> Int
    
    func distanceBetweenXStepsIn(_ graphCollectionView: UICollectionView) -> CGFloat
    
}

@objc public protocol CollectionGraphXDelegate: class {
    
    func bottomPaddingFor(_ graphCollectionView: UICollectionView) -> CGFloat
    
}

@objc public protocol CollectionGraphYDelegate: class {
    
    func leftSidePaddingFor(_ graphCollectionView: UICollectionView) -> CGFloat
    
}

@objc public protocol CollectionGraphBarGraphDelegate: class {
    
    func widthOfBarFor(_ graphCollectionView: UICollectionView) -> CGFloat
    
}
