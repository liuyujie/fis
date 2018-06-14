//
//  XCRPageContentView.swift
//  XCRScrollPageView
//
//  Created by liuyujie on 2018/6/14.
//  Copyright © 2018年 塞纳德（北京）信息技术有限公司. All rights reserved.
//

import UIKit


public protocol XCRPageContentViewDelegate: class {
    /// 有默认实现, 不推荐重写(override is not recommoned)
    func contentViewMoveToIndex(fromIndex: Int, toIndex: Int, progress: CGFloat)
    /// 有默认实现, 不推荐重写(override is not recommoned)
    func contentViewDidEndMoveToIndex(fromIndex: Int , toIndex: Int)
    
    func contentViewShouldBeginPanGesture(panGesture: UIPanGestureRecognizer , collectionView: UICollectionView) -> Bool;
    
    func contentViewDidBeginMove(scrollView: UIScrollView)
    
    func contentViewIsScrolling(scrollView: UIScrollView)
    func contentViewDidEndDisPlay(scrollView: UIScrollView)
    
    func contentViewDidEndDrag(scrollView: UIScrollView)
    /// 必须提供的属性
    var titleContentView: XCRPageTitleView { get }
}

// 由于每个遵守这个协议的都需要执行些相同的操作, 所以直接使用协议扩展统一完成,协议遵守者只需要提供segmentView即可
extension XCRPageContentViewDelegate {

    public func contentViewDidEndDrag(scrollView: UIScrollView) {
        
    }

    public func contentViewDidEndDisPlay(scrollView: UIScrollView) {
        
    }

    public func contentViewIsScrolling(scrollView: UIScrollView) {
        
    }
    // 默认什么都不做
    public func contentViewDidBeginMove(scrollView: UIScrollView) {
        
    }

    public func contentViewShouldBeginPanGesture(panGesture: UIPanGestureRecognizer , collectionView: UICollectionView) -> Bool {
        return true
    }
    
    // 内容每次滚动完成时调用, 确定title和其他的控件的位置
    public func contentViewDidEndMoveToIndex(fromIndex: Int , toIndex: Int) {
        titleContentView.adjustTitleOffSetToCurrentIndex(currentIndex: toIndex)
        titleContentView.adjustUIWithProgress(progress: 1.0, oldIndex: fromIndex, currentIndex: toIndex)
    }
    
    // 内容正在滚动的时候,同步滚动滑块的控件
    public func contentViewMoveToIndex(fromIndex: Int, toIndex: Int, progress: CGFloat) {
        titleContentView.adjustUIWithProgress(progress: progress, oldIndex: fromIndex, currentIndex: toIndex)
    }
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
    fileprivate var currentIndex = 1
    
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
    
    // update UI
    final public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(floor(scrollView.contentOffset.x / bounds.size.width))
        
        delegate?.contentViewDidEndDisPlay(scrollView: collectionView)
        delegate?.contentViewDidEndMoveToIndex(fromIndex: self.currentIndex, toIndex: currentIndex)
        
    }
    
    // 代码调整contentOffSet但是没有动画的时候不会调用这个
    final public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        delegate?.contentViewDidEndDisPlay(scrollView: collectionView)
        
    }
    
    final public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentIndex = Int(floor(scrollView.contentOffset.x / bounds.size.width))
        if let naviParentViewController = self.parentViewController?.parent as? UINavigationController {
            naviParentViewController.interactivePopGestureRecognizer?.isEnabled = true
        }
        delegate?.contentViewDidEndDrag(scrollView: scrollView)
//        print(scrollView.contentOffset.x)
        //快速滚动的时候第一页和最后一页(scroll too fast will not call 'scrollViewDidEndDecelerating')
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x == scrollView.contentSize.width - scrollView.bounds.width {
            if self.currentIndex != currentIndex {
                delegate?.contentViewDidEndMoveToIndex(fromIndex: self.currentIndex, toIndex: currentIndex)
            }
        }
    }
    
    // 手指开始拖的时候, 记录此时的offSetX, 并且表示不是点击title切换的内容(remenber the begin offsetX)
    final public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        /// 用来判断方向
        self.beginOffSetX = scrollView.contentOffset.x
        
        delegate?.contentViewDidBeginMove(scrollView: collectionView)
        
        self.forbidTouchToAdjustPosition = false
    }

    // 需要实时更新滚动的进度和移动的方向及下标 以便于外部使用 (compute the index and progress)
    final public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        // 如果是点击了title, 就不要计算了, 直接在点击相应的方法里就已经处理了滚动
        if forbidTouchToAdjustPosition {
            return
        }
        
        let temp = offSetX / bounds.size.width
        // 滚动的进度 -- 取小数位
        var progress = temp - floor(temp)
        // 根据滚动的方向
        if offSetX - beginOffSetX >= 0 {// 手指左滑, 滑块右移
            oldIndex = Int(floor(offSetX / bounds.size.width))
            currentIndex = oldIndex + 1
            if currentIndex >= childVCArray.count {
                currentIndex = oldIndex - 1
            }
            
            if offSetX - beginOffSetX == scrollView.bounds.size.width {// 滚动完成
                progress = 1.0;
                currentIndex = oldIndex;
            }
            
        } else {// 手指右滑, 滑块左移
            currentIndex = Int(floor(offSetX / bounds.size.width))
            oldIndex = currentIndex + 1
            progress = 1.0 - progress
        }
        
        //        print("\(progress)------\(oldIndex)----\(currentIndex)")
        
        delegate?.contentViewMoveToIndex(fromIndex: oldIndex, toIndex: currentIndex, progress: progress)

    }

}
