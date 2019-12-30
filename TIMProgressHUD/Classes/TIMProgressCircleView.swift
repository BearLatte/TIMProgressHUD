
public class TMProgressCircleView: UIView {
    @IBOutlet weak var progressIndicationLabel: UILabel!
    
    func setProgress(_ progress: CGFloat, text: String? = nil) {
        progressText = text
        progress_ = progress
        setNeedsDisplay()
        
    }
    private(set) var progress_: CGFloat = 0
    private var progressText: String?
    
    
    public override func draw(_ rect: CGRect) {
        
        let lineColor = self.tintColor ?? .white
        let linebgColor = lineColor.withAlphaComponent(0.1)
        let lineWidth: CGFloat = 2
        
        let size = bounds.size
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = (size.width - lineWidth) / 2
        let startAngle = -CGFloat.pi / 2
        var endAngle = CGFloat.pi * 2 + startAngle
        
        /// 绘制背景圆圈
        let bgPath = UIBezierPath()
        bgPath.lineWidth = lineWidth
        bgPath.lineCapStyle = .round
        bgPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        linebgColor.set()
        bgPath.stroke()
        
        
        /// 绘制进度圆圈
        let progressPath = UIBezierPath()
        progressPath.lineCapStyle = .round
        progressPath.lineWidth = lineWidth
        
        endAngle = progress_ * 2 * CGFloat.pi + startAngle
        progressPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        lineColor.set()
        progressPath.stroke()
        
        /// 显示进度文字
        progressIndicationLabel.text = progressText ?? String(format: "%.0f", progress_ * 100)
        progressIndicationLabel.textColor = lineColor
    }
}
