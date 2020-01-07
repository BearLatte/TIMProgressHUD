

public class TIMProgressView: UIView {
    
    /// 不同的状态显示不同的icon
    public enum Status {
        /// 无状态，显示纯文字
        case plain
        /// 执行中，显示菊花
        case running
        /// 进度，环形进度条
        case progress
        /// 成功，显示勾
        case succeed
        /// 错误，显示叉
        case error
        /// 自定义，显示自定义的 icon
        case custom
    }
    
    /// UI 样式配置选项，下次显示 HUD 时生效
    open var config: TIMProgressConfig = .default()
    
    /// 自定义的 icon 图片
    internal var customIcon: UIImage? = nil
    

    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var hudView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var activityView: UIActivityIndicatorView!
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private var progressCirleView: TMProgressCircleView!
    
    @IBOutlet private weak var effectView: UIVisualEffectView!
    
    @IBOutlet private weak var positionX: NSLayoutConstraint!
    @IBOutlet private weak var positionY: NSLayoutConstraint!
    @IBOutlet private weak var labelSpace: NSLayoutConstraint!
    @IBOutlet private weak var messageMinWidth: NSLayoutConstraint!
    @IBOutlet private weak var messageToTop: NSLayoutConstraint!
    
    weak private var parent: UIView?
    private var status_: Status = .plain
    private var message_: String?
    private var progressInCircleText_: String?
    private var progress_: CGFloat = 0
    private var isShown = false
}

// MARK: - Public APIS
extension TIMProgressView {
    
    /// 快速显示一个消息提示
    /// - Parameters:
    ///   - message: 文字提示
    ///   - delay: 显示时长，默认不隐藏
    public func showMessage(_ message: String, hiddenDelay delay: TimeInterval = 0) {
        show(message: message, hiddenDelay: delay)
    }
    
    /// 快速显示纯文本消息提示
    /// - Parameters:
    ///   - message: 提示文字
    ///   - delay: 自动隐藏时间，默认 1 秒后隐藏
    public func showTextMessage(message: String, hiddenDelay delay: TimeInterval = 1) {
        show(.plain, message: message, hiddenDelay: delay)
    }

    /// 显示菊花
    /// - Parameters:
    ///   - status: 显示的状态
    ///   - message: 状态说明文字，可选值，如果传 nil 只显示菊花
    ///   - delay: 多长时间后自动隐藏，默认为 0 不隐藏
    public func show(_ status: Status = .running, message: String? = nil, hiddenDelay delay: TimeInterval = 0) {
        status_ = status
        message_ = message
        
        updateStatusShow()
        
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
                self.hiddenHUD()
            }
        }
    }
    
    /// 显示处理进度
    /// - Parameters:
    ///   - progress: 当前进度值，范围 0.0 ~~ 1.0
    ///   - message: 状态文字, 例如：正在加载...
    ///   - progressText: 进度圈内文字，默认为百分比
    public func show(progress: CGFloat, message: String? = nil, progressInCircleText: String? = nil) {
        progress_ = progress
        progressInCircleText_ = progressInCircleText
        show(.progress, message: message, hiddenDelay: 0)
    }
    
    /// 显示自定义动画
    /// - Parameters:
    ///   - customIcon: 自定义图标，会被转换为 Template 模式
    ///   - message: 状态文字，默认为 nil
    ///   - delay: 自动隐藏时间，单位 秒，默认 0，默认不隐藏
    internal func show(customIcon: UIImage, message: String? = nil, hiddenDelay delay: TimeInterval = 0) {
        self.customIcon = customIcon
        show(.custom, message: message, hiddenDelay: delay)
    }
    
    /// 隐藏HUD
    public func hiddenHUD() {
        hideHUD()
    }
}

// MARK: - Private
extension TIMProgressView {
    private static var bundle: Bundle {
        var bundle = Bundle.main
        let framework = Bundle(for: TIMProgressView.self)
        if let resource = framework.path(forResource: "TIMProgressHUD", ofType: "bundle") {
            bundle = Bundle(path: resource) ?? Bundle.main
        }
        return bundle
    }
    
    internal static func progressView(withView parent: UIView) -> TIMProgressView? {
        if let views = bundle.loadNibNamed("TIMProgressView", owner: nil, options: nil) as? [TIMProgressView],
        views.count > 0 {
            let progressView = views[0]
            progressView.setup(withView: parent)
            return progressView
        }
        return nil
    }
    
    private func setup(withView view: UIView) {
        view.addSubview(self)

        parent = view
        pinEdgesToParent()
        isHidden = true
        
        hudView.layer.cornerRadius = 8
        hudView.clipsToBounds = true
    }
    
    private func pinEdgesToParent() {
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        
        guard let parent = parent else {
            return
        }

        let top = pinToParent(withEdge: .top)
        let bottom = pinToParent(withEdge: .bottom)
        let left = pinToParent(withEdge: .leading)
        let right = pinToParent(withEdge: .trailing)
        
        parent.addConstraints([top, bottom, left, right])
        
        DispatchQueue.main.async {
            self.parent?.layoutIfNeeded()
        }
    }
    
    private func pinToParent(withEdge edge: NSLayoutConstraint.Attribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: parent!, attribute: edge, relatedBy: .equal, toItem: self, attribute: edge, multiplier: 1, constant: 0)
    }
    
    private func updateStatusShow() {
        if iconView.isAnimating {
            iconView.stopAnimating()
            iconView.animationImages = nil
        }

        messageLabel.text = message_;
        updateMessageTextAlignment()
        
        positionX.constant = config.offsetX
        positionY.constant = config.offsetY
        
        backgroundView.backgroundColor = config.maskColor

        effectView.effect = UIBlurEffect(style: config.hudStyle)

        iconView.tintColor = config.color
        activityView.tintColor = config.color
        progressCirleView.tintColor = config.color
        messageLabel.textColor = config.color
        
        if message_ != nil && !message_!.isEmpty{
            labelSpace.constant = 8
            messageMinWidth.constant = 70
        }else {
            labelSpace.constant = 4
            messageMinWidth.constant = 50
        }
        
        messageToTop.constant = 64
        activityView.isHidden = true
        progressCirleView.isHidden = true
        iconView.isHidden = true
        
        switch status_ {
        case .plain:
            messageToTop.constant = 16
        case .running:
            setupActivityViewForRunning()
        case .progress:
            progressCirleView.isHidden = false
            progressCirleView.setProgress(progress_, text: progressInCircleText_)
        case .succeed:
            iconView.isHidden = false
            iconView.image = image(name: "check")
        case .error:
            iconView.isHidden = false
            iconView.image = image(name: "cross")
        case .custom:
            iconView.isHidden = false
            iconView.image = customIcon
        }
        
        layoutIfNeeded()
        showHUD()
    }
    
    private func setupActivityViewForRunning() {
        if let activityStyle = config.indicatorStyle.activityStyle {
            activityView.isHidden = false
            activityView.style = activityStyle
        } else if case let .animationImages(images) = config.indicatorStyle {
            activityView.isHidden = true
            iconView.isHidden = false
            iconView.animationImages = images
            iconView.animationDuration = Double(images.count) * config.animationDuration
            iconView.startAnimating()
        } else {
            // do nothing
        }
    }
    
    private func updateMessageTextAlignment() {
        if status_ == .plain {
            messageLabel.textAlignment = .left
        }else {
            messageLabel.textAlignment = .center
        }
    }
    
    private func image(name: String) -> UIImage? {
           return UIImage(named: "hud_\(name).png", in: TIMProgressView.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
       }
    
    private func showHUD() {
        
        if isShown {
            return
        }
        
        isShown = true
        isHidden = false
        alpha = 0
        parent?.bringSubviewToFront(self)
        parent?.layoutIfNeeded()
        layer.removeAllAnimations()

        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
    
    private func hideHUD() {
        if !isShown {
            return
        }
        
        isShown = false
        
        layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 0
        }) { (finished) in
            if finished {
                self.isHidden = true
                self.reset()
            }
        }
    }
    
    private func reset() {
        iconView.image = nil
        customIcon = nil
        message_ = nil
        progress_ = 0
        progressCirleView.setProgress(0)
        iconView.animationImages = nil
        iconView.stopAnimating()
    }
}
