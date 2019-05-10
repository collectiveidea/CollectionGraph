
import UIKit

open class BaseHorizontalDividerLineReusableView: UICollectionReusableView {
    
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
    }
    
    open override func layoutSubviews() {
        line.frame = bounds
    }
    
}
