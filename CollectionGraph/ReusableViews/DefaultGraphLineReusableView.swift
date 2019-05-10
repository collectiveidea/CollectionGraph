
import UIKit

public class DefaultGraphLineReusableView: BaseGraphLineReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        line.lineWidth = 1
        line.strokeColor = UIColor.black.cgColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
