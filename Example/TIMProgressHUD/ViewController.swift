//
//  ViewController.swift
//  TIMProgressHUD
//
//  Created by Tim on 12/30/2019.
//  Copyright (c) 2019 Tim. All rights reserved.
//

import UIKit
import TIMProgressHUD

class ViewController: UIViewController {

    var configs = [TIMProgressConfig]()
    override func viewDidLoad() {
        super.viewDidLoad()
        TIMProgressConfig.default().color = .red
        configs.append(TIMProgressConfig.default())

        let lightConfig = TIMProgressConfig("light")
        lightConfig.hudStyle = .light
        lightConfig.color    = .black
        lightConfig.indicatorStyle = .grayStyle
        lightConfig.maskColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        configs.append(lightConfig)

        let darkConfig = TIMProgressConfig("dark")
        darkConfig.hudStyle = .dark
        darkConfig.color = .white
        darkConfig.indicatorStyle = .whiteLargeStyle
        darkConfig.maskColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        configs.append(darkConfig)

        let animationConfig = TIMProgressConfig("animation")
        var images = [UIImage]()
        for i in 1 ... 9 {
            images.append(UIImage(named: "indicator_\(i)") ?? UIImage())
        }
        animationConfig.hudStyle = .dark
        animationConfig.color = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        animationConfig.indicatorStyle = .animationImages(images)
        animationConfig.animationDuration = 0.08
        configs.append(animationConfig)
    }
    
    
    
    @IBAction func showAction(_ sender: Any) {
        tm.progressHUD?.showTextMessage(message: "Swift 社区最近最重大的新闻应该就是 ABI 稳定了。这个话题虽然已经讨论了有一阵子了，但随着 Xcode 10.2 beta 的迭代和 Swift 5 的 release 被提上日程，最终 Swift ABI 稳定能做到什么程度，我们开发者能做些什么，需要做些什么，就变成了一个重要的话题。Apple 在这个月接连发布了 ABI Stability and More 和 Evolving Swift On Apple Platforms After ABI Stability 两篇文章来阐述 Swift 5 发布以后 ABI 相关的内容所带来的改变。虽然原文不是很长，但是有些地方上下文没有说太清楚，可能不太容易理解。本文希望对这个话题以问答的形式进行一些总结，让大家能更明白将要发生的事情。")
    }
    
    
    @IBAction func showMessageAction(_ sender: Any) {
        tm.progressHUD?.showMessage("正在加载...")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.tm.progressHUD?.show(.succeed, message: "处理完毕", hiddenDelay: 1)
        }
    }
    
    @IBAction func showProgressAction(_ sender: Any) {
        func updateProgress(progress: CGFloat) {
            if progress > 1 {
                tm.progressHUD?.show(.succeed, message: "处理完成", hiddenDelay: 1)
            } else {
                let pString = String(format: "%.0f", progress * 100)
                tm.progressHUD?.show(progress: progress, message: "正在处理...", progressInCircleText: pString)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    updateProgress(progress: progress + 0.001)
                }
            }
        }

        updateProgress(progress: 0)
    }
    
    
    @IBAction func showProgressWithCustomTextAction(_ sender: Any) {
        func updateCount(finished: Int) {
            if finished > 10 {
                tm.progressHUD?.show(.succeed, message: "处理完成", hiddenDelay: 1)
            } else {
                let progress = CGFloat(finished) / 10.0
                tm.progressHUD?.show(progress: progress, message: "处理中...", progressInCircleText: "\(finished)/10")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    updateCount(finished: finished + 1)
                }
            }
        }

        updateCount(finished: 0)
    }
        
    @IBAction func changeStyleAction(_ sender: Any) {
        index += 1
        if index == configs.count {
            index = 0
        }

        let config = configs[index]
        tm.progressHUD?.config = config
        tm.progressHUD?.show(.plain, message: "changed to \(config.name!)", hiddenDelay: 1)
    }
    
    private var index = 0

}

