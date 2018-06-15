//
//  XCRScrollPageView.swift
//  XCRScrollPageView
//
//  Created by liuyujie on 2018/6/14.
//  Copyright © 2018年 塞纳德（北京）信息技术有限公司. All rights reserved.
//

import UIKit

public class XCRScrollPageView: UIView {
    
    private var titleStyle = XCRPageTitleStyle()
    public var parentViewController : UIViewController?
    private var titleView: XCRPageTitleView!
    private(set) var pageContentView: XCRPageContentView!
    var childVCArray: [UIViewController] = []
    var titleArray: [String] = []
    var selectIndex : Int {
        return pageContentView.currentIndex
    }
    
    public init(frame:CGRect, titleStyle: XCRPageTitleStyle, titles: [String], childVCs:[UIViewController], parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        self.childVCArray = childVCs
        self.titleArray = titles
        self.titleStyle = titleStyle
        assert(childVCs.count == titles.count, "标题的个数必须和子控制器的个数相同")
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(){
        
        backgroundColor = UIColor.white
        titleView = XCRPageTitleView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 44), titleStyle: titleStyle, titles: titleArray)
        
        guard let parentVc = parentViewController else { return }
        
        pageContentView = XCRPageContentView(frame: CGRect(x: 0, y: titleView.frame.maxY, width: bounds.size.width, height: bounds.size.height - 44), childVCArray: childVCArray, parentViewController: parentVc)
        pageContentView.delegate = self

        addSubview(titleView)
        addSubview(pageContentView)
        
        // 避免循环引用
        titleView.titleBtnOnClick = {[unowned self] (label: UILabel, index: Int) in
            // 切换内容显示(update content)
//            self.pageContentView.setContentOffSet(CGPoint(x: self.contentView.bounds.size.width * CGFloat(index), y: 0), animated: self.segmentStyle.changeContentAnimated)
            
            self.pageContentView.scrollTo(index,animated: self.titleStyle.changeContentAnimated)
        }

    }
    
    
}

extension XCRScrollPageView: XCRPageContentViewDelegate {
    public var titleContentView: XCRPageTitleView {
        return self.titleView
    }

    
}

