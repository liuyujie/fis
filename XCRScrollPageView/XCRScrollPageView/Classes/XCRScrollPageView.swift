//
//  XCRScrollPageView.swift
//  XCRScrollPageView
//
//  Created by liuyujie on 2018/6/14.
//  Copyright © 2018年 塞纳德（北京）信息技术有限公司. All rights reserved.
//

import UIKit
import XCRTitleScrollView

public protocol XCRScrollPageViewDelegate: NSObjectProtocol {

    func scrollPageViewWillBeginDragging(_ scrollView: UIScrollView)

    func scrollPageViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
}

public class XCRScrollPageView: UIView {

    private var titleStyle: XCRTitleScrollViewStyle!
    public var parentViewController: UIViewController?
    public weak var pageDelegate: XCRScrollPageViewDelegate?

    private var titleView: XCRTitleScrollView!
    private(set) var pageContentView: XCRPageContentView!
    var childVCArray: [UIViewController] = []
    var titleArray: [String] = []
    var selectIndex: Int = 0

    public init(frame: CGRect, titleStyle: XCRTitleScrollViewStyle, titles: [String], childVCs: [UIViewController], parentViewController: UIViewController) {
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

    private func commonInit() {

        backgroundColor = UIColor.white

        titleView = XCRTitleScrollView(style: titleStyle)
        titleView.alwaysBounceHorizontal = true
        titleView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 44)
        titleView.titles = titleArray
        titleView.backgroundColor = UIColor.cFFFFFF
        titleView.updateTheme()

        guard let parentVc = parentViewController else { return }
        pageContentView = XCRPageContentView(frame: CGRect(x: 0, y: titleView.frame.maxY, width: bounds.size.width, height: bounds.size.height - 44), childVCArray: childVCArray, parentViewController: parentVc)
        pageContentView.delegate = self
        addSubview(titleView)
        addSubview(pageContentView)

        titleView.reloadTitles()

        titleView.handleSelectButton = { [unowned self](selectedIndex, _) in
            self.pageContentView.scrollTo(selectedIndex, animated: false)
        }
    }
}

extension XCRScrollPageView: XCRPageContentViewDelegate {

    public var titleContentView: XCRTitleScrollView {
        return self.titleView
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        titleContentView.scrollTitleButton(scrollView.contentOffset.x)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.pageDelegate?.scrollPageViewWillBeginDragging(scrollView)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.pageDelegate?.scrollPageViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }

    public func pageScrollDidSelected(_ index: Int) {
        selectIndex = index
        titleContentView.selectedTitle(at: selectIndex, animated: false)
    }
}
