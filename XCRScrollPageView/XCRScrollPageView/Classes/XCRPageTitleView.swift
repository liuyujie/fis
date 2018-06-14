//
//  XCRPageTitleView.swift
//  XCRScrollPageView
//
//  Created by liuyujie on 2018/6/14.
//  Copyright © 2018年 塞纳德（北京）信息技术有限公司. All rights reserved.
//

import UIKit

public class XCRPageTitleView: UIView {

    public var titleStyle: XCRPageTitleStyle

    /// 点击响应的closure(click title)
    public var titleBtnOnClick:((_ label: UILabel,_ index: Int) -> Void)?
    
    /// 附加按钮点击响应(click extraBtn)
    public var moreBtnOnClick: ((_ extraBtn: UIButton) -> Void)?
    
    
    
    private var scrollView: UIScrollView!
    
    /// self.bounds.size.width
    private var currentWidth: CGFloat = 0
    
    /// 遮盖x和文字x的间隙
    private var xGap = 5
    
    /// 遮盖宽度比文字宽度多的部分
    private var wGap: Int {
        return 2 * xGap
    }

    /// 滚动条
    private lazy var scrollLine : UIView? = {[unowned self] in
        let line = UIView()
        return self.titleStyle.showLine ? line : nil
    }()
    
    /// 遮盖
    private lazy var coverLayer: UIView? = {[unowned self] in
        
        if !self.titleStyle.showCover {
            return nil
        }
        let cover = UIView()
        cover.layer.cornerRadius = self.titleStyle.coverCornerRadius
        // 这里只有一个cover 需要设置圆角, 故不用考虑离屏渲染的消耗, 直接设置 masksToBounds 来设置圆角
        cover.layer.masksToBounds = true
        return cover
    }()
    
    /// 缓存标题labels( save labels )
    private var labelsArray: [UILabel] = []
    
    /// 记录当前选中的下标
    private var currentIndex = 0
    /// 记录上一个下标
    private var oldIndex = 0
    /// 用来缓存所有标题的宽度, 达到根据文字的字数和font自适应控件的宽度(save titles; width)
    private var titlesWidthArray: [CGFloat] = []
    /// 所有的标题
    private var titleArray:[String]

    
    /// 附加的按钮
    private lazy var extraButton: UIButton? = {[unowned self] in
        if !self.titleStyle.showExtraButton {
            return nil
        }
        let btn = UIButton(type : .custom)
//        btn.addTarget(self, action: #selector(self.moreBtnOnClick(_:)), for: .touchUpInside)
        // 默认 图片名字
        let imageName = self.titleStyle.extraBtnBackgroundImageName ?? ""
        btn.setImage(UIImage(named:imageName), for: .normal)
        btn.backgroundColor = UIColor.white
        // 设置边缘的阴影效果
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowOffset = CGSize(width: -5, height: 0)
        btn.layer.shadowOpacity = 1
        return btn
    }()
    
    //MARK:- life cycle
    public init(frame: CGRect, titleStyle: XCRPageTitleStyle, titles: [String]) {
        self.titleStyle = titleStyle
        self.titleArray = titles
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.orange
        
        if !self.titleStyle.scrollTitle {
            self.titleStyle.scaleTitle = !(self.titleStyle.showCover || self.titleStyle.showLine)
        }
        
        scrollView = UIScrollView(frame: frame)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true
        scrollView.isPagingEnabled = false
        scrollView.isScrollEnabled = false
        self.addSubview(scrollView)
        initTitleLabel()
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 手动滚动时需要提供动画效果
    public func adjustUIWithProgress(progress: CGFloat,  oldIndex: Int, currentIndex: Int) {
        // 记录当前的currentIndex以便于在点击的时候处理
        self.oldIndex = currentIndex
        
        //        print("\(currentIndex)------------currentIndex")
        
        let oldLabel = labelsArray[oldIndex] as! XCRCustomLabel
        let currentLabel = labelsArray[currentIndex] as! XCRCustomLabel
        
        // 从一个label滚动到另一个label 需要改变的总的距离 和 总的宽度
        let xDistance = currentLabel.frame.origin.x - oldLabel.frame.origin.x
        let wDistance = currentLabel.frame.size.width - oldLabel.frame.size.width
        
        // 设置滚动条位置 = 最初的位置 + 改变的总距离 * 进度
        scrollLine?.frame.origin.x = oldLabel.frame.origin.x + xDistance * progress
        // 设置滚动条宽度 = 最初的宽度 + 改变的总宽度 * 进度
        scrollLine?.frame.size.width = oldLabel.frame.size.width + wDistance * progress
        
        
        // 设置 cover位置
        if titleStyle.scrollTitle {
            coverLayer?.frame.origin.x = oldLabel.frame.origin.x + xDistance * progress - CGFloat(xGap)
            coverLayer?.frame.size.width = oldLabel.frame.size.width + wDistance * progress + CGFloat(wGap)
        } else {
            coverLayer?.frame.origin.x = oldLabel.frame.origin.x + xDistance * progress
            coverLayer?.frame.size.width = oldLabel.frame.size.width + wDistance * progress
        }
    
    
        // 缩放文字
        
        guard titleStyle.scaleTitle else {
            return
        }
        
        // 注意左右间的比例是相关连的, 加减相同
        // 设置文字缩放
        let deltaScale = (titleStyle.titleBigScale - titleStyle.titleOriginalScale)

        oldLabel.currentTransformSx = titleStyle.titleBigScale - deltaScale * progress
        currentLabel.currentTransformSx = titleStyle.titleOriginalScale + deltaScale * progress
        
    }
    // 居中显示title
    public func adjustTitleOffSetToCurrentIndex(currentIndex: Int) {
        
        let currentLabel = labelsArray[currentIndex]
        
        
        for (index,label) in labelsArray.enumerated() {
            if index != currentIndex {
                label.textColor = self.titleStyle.normalTitleColor
            }
        }
        
        // 目标是让currentLabel居中显示
        var offSetX = currentLabel.center.x - currentWidth / 2
        if offSetX < 0 {
            // 最小为0
            offSetX = 0
        }
        // considering the exist of extraButton
        let extraBtnW = extraButton?.frame.size.width ?? 0.0
        var maxOffSetX = scrollView.contentSize.width - (currentWidth - extraBtnW)
        
        // 可以滚动的区域小余屏幕宽度
        if maxOffSetX < 0 {
            maxOffSetX = 0
        }
        
        if offSetX > maxOffSetX {
            offSetX = maxOffSetX
        }
        
        scrollView.setContentOffset(CGPoint(x:offSetX, y: 0), animated: true)
        
        // 没有渐变效果的时候设置切换title时的颜色
        if !titleStyle.gradualChangeTitleColor {
            
            for (index, label) in labelsArray.enumerated() {
                if index == currentIndex {
                    label.textColor = titleStyle.selectedTitleColor
                } else {
                    label.textColor = titleStyle.normalTitleColor
                }
            }
        }
        //        print("\(oldIndex) ------- \(currentIndex)")
        
    }
    
    private func initTitleLabel() {
        
        for (index, title) in titleArray.enumerated() {
            let label = XCRCustomLabel(frame: CGRect.zero)
            label.tag = index
            label.text = title
            label.textColor = titleStyle.normalTitleColor
            label.font = titleStyle.titleFont
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            
//            // 添加点击手势
//            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleBtnOnClick(_:)))
//            label.addGestureRecognizer(tapGes)
            // 计算文字尺寸
            label.sizeToFit()
            // 缓存文字宽度
            titlesWidthArray.append(label.frame.size.width)
            // 缓存label
            labelsArray.append(label)
            // 添加label
            scrollView.addSubview(label)
        }
    }
    
    // 先设置label的位置
    private func layoutTitleLabel() {
        
        var titleX: CGFloat = 0.0
        let titleY: CGFloat = 0.0
        var titleW: CGFloat = 0.0
        let titleH = bounds.size.height - titleStyle.scrollLineHeight
        
        if !titleStyle.scrollTitle {// 标题不能滚动, 平分宽度
            titleW = currentWidth / CGFloat(titleArray.count)
            
            for (index, label) in labelsArray.enumerated() {
                titleX = CGFloat(index) * titleW
                label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            }
            
        } else {
            for (index, label) in labelsArray.enumerated() {
                titleW = titlesWidthArray[index]
                titleX = titleStyle.titleMargin
                if index != 0 {
                    let lastLabel = labelsArray[index - 1]
                    titleX = lastLabel.frame.maxX + titleStyle.titleMargin
                }
                label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            }
        }
        
        if let firstLabel = labelsArray[0] as? XCRCustomLabel {
            if titleStyle.scaleTitle {
                firstLabel.currentTransformSx = titleStyle.titleBigScale
            }
            firstLabel.textColor = titleStyle.selectedTitleColor
        }
    }
    
    private func setupUI() {
        
//        // 设置extra按钮
//        setupScrollViewAndExtraBtn()
//
//        // 先设置label的位置
        layoutTitleLabel()
//        // 再设置滚动条和cover的位置
//        setupScrollLineAndCover()
        
        
        
        
        if titleStyle.scrollTitle { // 设置滚动区域
            if let lastLabel = labelsArray.last {
                scrollView.contentSize = CGSize(width: lastLabel.frame.maxX + titleStyle.titleMargin, height: 0)
            }
        }
        
    }
    
    public func selectedIndex(_ index: Int, animated: Bool) {
        assert(!(index < 0 || index >= titleArray.count), "设置的下标不合法!!")
        
        if index < 0 || index >= titleArray.count {
            return
        }
        
        // 自动调整到相应的位置
        currentIndex = index
        
        //        print("\(oldIndex) ------- \(currentIndex)")
        // 可以改变设置下标滚动后是否有动画切换效果
//        adjustUIWhenBtnOnClickWithAnimate(animated)
    }
    
    // 暴露给外界来刷新标题的显示
    public func reloadTitles(titleArray: [String]) {
        // 移除所有的scrollView子视图
        scrollView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        // 移除所有的label相关
        titlesWidthArray.removeAll()
        labelsArray.removeAll()
        
        // 重新设置UI
        self.titleArray = titleArray
        initTitleLabel()
        setupUI()
        // default selecte the first tag
        selectedIndex(0, animated: true)
    }
    
}
public class XCRCustomLabel: UILabel {
    /// 用来记录当前label的缩放比例
    public var currentTransformSx:CGFloat = 1.0 {
        didSet {
            transform = CGAffineTransform(scaleX: currentTransformSx, y: currentTransformSx)
        }
    }
}
