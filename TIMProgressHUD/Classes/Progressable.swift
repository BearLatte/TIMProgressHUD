
import Foundation

public struct TM<Base> {
    public var base: Base
    init(_ base: Base) {
        self.base = base
    }
}


public protocol Progressable {}
public extension Progressable {
    var tm: TM<Self> {
        set{}
        get { TM(self) }
    }
    static var tm: TM<Self>.Type {
        set {}
        get { TM<Self>.self }
    }
}

extension UIView: Progressable {}
public extension TM where Base: UIView {
    var progressHUD: TIMProgressView? {
        set {}
        get {
            var progress: TIMProgressView?
            for view in base.subviews where view.isKind(of: UIView.self) {
                progress = view as? TIMProgressView
            }
            
            if progress == nil {
                progress = TIMProgressView.progressView(withView: base)
            }
            
            return progress
        }
    }
}

extension UIViewController: Progressable {}
public extension TM where Base: UIViewController {
    var progressHUD: TIMProgressView? {
        set {}
        get {
            var progress: TIMProgressView?
            for view in base.view.subviews where view.isKind(of: UIView.self) {
                progress = view as? TIMProgressView
            }
            
            if progress == nil {
                progress = TIMProgressView.progressView(withView: base.view)
            }
            
            return progress
        }
    }
}
