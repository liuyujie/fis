//
//  XCRTableView.swift
//  XCRScrollPageView
//
//  Created by Liuyujie on 2018/6/14.
//  Copyright © 2018年 塞纳德（北京）信息技术有限公司. All rights reserved.
//
import UIKit

class XCRTableView: UITableView,UIGestureRecognizerDelegate {
    
    var shouldHandelBlock : ((_ selfGesture: UIGestureRecognizer, _ otherGestur: UIGestureRecognizer) -> Bool)?
    var panGestureManager : XCRPanGestureManager?
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let block = shouldHandelBlock {
            return block(gestureRecognizer,otherGestureRecognizer)
        }
        return false
//        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}

protocol XCRPanGestureHandelable : NSObjectProtocol {
    /// 手势状态管理
    var panGestureManager : XCRPanGestureManager? { get set }
    /// 上一次ScrollView最后的位置
    var previousOffset : CGPoint? { get set }
}

extension XCRPanGestureHandelable {
    ///  处理 scrollView 内容偏移
    ///
    /// - Parameter scrollView: 显示数据的View
    public func handleShowVCOffsetChanged(_ scrollView: UIScrollView){
        
        let y = scrollView.contentOffset.y
        
        if let panGestureManager = panGestureManager {
            
            panGestureManager.showVCOffsetY = y
            
            if !panGestureManager.showVCCanScroll {
                scrollView.contentOffset = CGPoint.zero
                panGestureManager.showVCOffsetY = 0
            }

            if y <= 0 {
                panGestureManager.showVCCanScroll = false
                scrollView.contentOffset = CGPoint.zero
                panGestureManager.showVCOffsetY = 0
            }
            
            previousOffset = scrollView.contentOffset
        }
    }
    
}

class XCRPanGestureManager: NSObject {
    
    var headerHeight: CGFloat = 0
    var rootVCShowRefresh: Bool = true
    var rootVCCanScroll: Bool = true
    var showVCCanScroll: Bool = false

    var rootVCOffsetY: CGFloat = 0
    var showVCOffsetY: CGFloat = 0
    
    public func handleRootVCOffsetChanged(_ scrollView: UIScrollView) {
    
        rootVCOffsetY = scrollView.contentOffset.y
        if rootVCOffsetY >= headerHeight {
            scrollView.contentOffset = CGPoint(x: 0, y: headerHeight)
            rootVCOffsetY = headerHeight
            if (rootVCCanScroll) {
                rootVCCanScroll = false
                showVCCanScroll = true
            }
        } else {
            if !rootVCCanScroll {//子视图没到顶部
                scrollView.contentOffset = CGPoint(x: 0, y: headerHeight)
                rootVCOffsetY = headerHeight
            }
        }
    
        if !showVCCanScroll && !rootVCCanScroll {
            rootVCCanScroll = true
        }
        
        scrollView.showsVerticalScrollIndicator = false
    }
    
}
