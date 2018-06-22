//
//  XCRPageContentView.swift
//  XCRScrollPageView
//
//  Created by liuyujie on 2018/6/14.
//  Copyright © 2018年 塞纳德（北京）信息技术有限公司. All rights reserved.
//

import UIKit
import XCRTitleScrollView


public protocol XCRPageContentViewDelegate: UIScrollViewDelegate {
    
    /// 必须提供的属性
    var titleContentView: XCRTitleScrollView { get }
}



class XCRPageContentView: UIView {
    static let cellId = "XCRPageContentCellId"

    /// 所有的子控制器
    private var childVCArray: [UIViewController] = []
    // 这里使用weak 避免循环引用
    private weak var parentViewController: UIViewController?
    
    private var collectionView : UICollectionView!
    
    /// 用来判断是否是点击了title, 点击了就不要调用scrollview的代理来进行相关的计算
    fileprivate var forbidTouchToAdjustPosition = false
    /// 用来记录开始滚动的offSetX
    fileprivate var beginOffSetX:CGFloat = 0.0
    private var oldIndex = 0
    
    var currentIndex = 0
    
    public weak var delegate: XCRPageContentViewDelegate?


    public init(frame:CGRect, childVCArray:[UIViewController], parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        self.childVCArray = childVCArray
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(){
     
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.isDirectionalLockEnabled = true
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: XCRPageContentView.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        addSubview(collectionView)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = bounds.size
        let vc = childVCArray[currentIndex]
        vc.view.frame = bounds
    }
    
    public func scrollTo(_ index: Int, animated: Bool){
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionViewScrollPosition(), animated: animated)
    }
    
    // 给外界刷新视图的方法(public method to reset childVcs)
    public func reloadAll(newChildArray: [UIViewController] ) {
        
        childVCArray.forEach { (childVC) in
            childVC.willMove(toParentViewController: nil)
            childVC.view.removeFromSuperview()
            childVC.removeFromParentViewController()
        }
        
        childVCArray.removeAll()
        childVCArray = newChildArray
        
        // 不要添加navigationController包装后的子控制器
        for childVC in childVCArray {
            if childVC.isKind(of:UINavigationController.self) {
                fatalError("不要添加UINavigationController包装后的子控制器")
            }
            parentViewController?.addChildViewController(childVC)
        }
        collectionView.reloadData()
    }
    
    deinit {
        parentViewController = nil
        print("\(self.debugDescription) --- 销毁")
    }
}


extension XCRPageContentView : UICollectionViewDataSource , UICollectionViewDelegate {
    
    // 发布通知
    private func postShowIndexNotification(index: Int) {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "post"), object: nil, userInfo: ["index":index])
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.childVCArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XCRPageContentView.cellId, for: indexPath)
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let vc = childVCArray[indexPath.row]
        vc.view.frame = bounds
        cell.contentView.addSubview(vc.view)
        vc.didMove(toParentViewController: parentViewController)
        postShowIndexNotification(index: indexPath.row)
        return cell
    }
}


// MARK: - UIScrollViewDelegate
extension XCRPageContentView: UIScrollViewDelegate {
    
    final public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        self.currentIndex = Int(floor(offSetX / bounds.size.width))
        delegate?.scrollViewDidScroll?(scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
//    final public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let currentIndex = Int(floor(scrollView.contentOffset.x / bounds.size.width))
//        if let naviParentViewController = self.parentViewController?.parent as? UINavigationController {
//            naviParentViewController.interactivePopGestureRecognizer?.isEnabled = true
//        }
//        delegate?.contentViewDidEndDrag(scrollView: scrollView)
////        print(scrollView.contentOffset.x)
//        //快速滚动的时候第一页和最后一页(scroll too fast will not call 'scrollViewDidEndDecelerating')
//        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x == scrollView.contentSize.width - scrollView.bounds.width {
//            if self.currentIndex != currentIndex {
//                delegate?.contentViewDidEndMoveToIndex(fromIndex: self.currentIndex, toIndex: currentIndex)
//            }
//        }
//    }
//
//    // 手指开始拖的时候, 记录此时的offSetX, 并且表示不是点击title切换的内容(remenber the begin offsetX)
//    final public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        /// 用来判断方向
//        self.beginOffSetX = scrollView.contentOffset.x
//        self.forbidTouchToAdjustPosition = false
//    }



}
