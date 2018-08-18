//
//  XCRTableView.swift
//  XCRScrollPageView
//
//  Created by Liuyujie on 2018/6/14.
//  Copyright © 2018年 塞纳德（北京）信息技术有限公司. All rights reserved.
//
import UIKit

class XCRTableView: UITableView, UIGestureRecognizerDelegate {

    var shouldHandelBlock : ((_ selfGesture: UIGestureRecognizer, _ otherGestur: UIGestureRecognizer) -> Bool)?
    var panGestureManager: XCRPanGestureManager?

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let block = shouldHandelBlock {
            return block(gestureRecognizer, otherGestureRecognizer)
        }
        return false
//        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}

protocol XCRPanGestureHandelable: NSObjectProtocol {
    /// 手势状态管理
    var panGestureManager: XCRPanGestureManager? { get set }
    /// 上一次ScrollView最后的位置
    var previousOffset: CGPoint? { get set }
}

extension XCRPanGestureHandelable {
    ///  处理 scrollView 内容偏移
    ///
    /// - Parameter scrollView: 显示数据的View
    public func handleShowVCOffsetChanged(_ scrollView: UIScrollView) {

        let y = scrollView.contentOffset.y

        if let manager = panGestureManager {

            manager.showVCOffsetY = y

            if manager.rootVCShowRefresh {
                if y <= 0 {
                    previousOffset = CGPoint.zero
                    manager.showVCCanScroll = false
                    scrollView.contentOffset = CGPoint.zero
                    manager.showVCOffsetY = 0
                }
            }

            if !manager.showVCCanScroll {

                if let offset = previousOffset {
                    let offsetY = offset.y
                    if  offsetY > 0 {
                        if manager.rootVCOffsetY >= 0 {
                            scrollView.contentOffset = offset
                            manager.showVCOffsetY = offsetY
                        } else {
                            manager.canShowRefresh = false
                        }
                    }
                } else {
                    scrollView.contentOffset = CGPoint.zero
                    manager.showVCOffsetY = 0

                }

            }

//            if y <= 0 {
//                panGestureManager.showVCCanScroll = false
//                if let of = previousOffset {
//                    print(of)
//                    scrollView.contentOffset = of
//                    panGestureManager.showVCOffsetY = 0
//                } else {
//                    scrollView.contentOffset = CGPoint.zero
//                    panGestureManager.showVCOffsetY = 0
//
//                }
////                scrollView.contentOffset = CGPoint.zero
////                panGestureManager.showVCOffsetY = 0
//            }

            previousOffset = scrollView.contentOffset

        }
    }

}

class XCRPanGestureManager: NSObject {

    var headerHeight: CGFloat = 0
    var rootVCShowRefresh: Bool = true
    var canShowRefresh: Bool = true

    var rootVCCanScroll: Bool = true
    var showVCCanScroll: Bool = false

    var rootVCOffsetY: CGFloat = 0
    var showVCOffsetY: CGFloat = 0

    public func handleRootVCOffsetChanged(_ scrollView: UIScrollView) {

        rootVCOffsetY = scrollView.contentOffset.y

        if rootVCOffsetY < 0 {
            if !rootVCShowRefresh || !canShowRefresh {
                scrollView.contentOffset = CGPoint.zero
            }
        }

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
        scrollView.showsHorizontalScrollIndicator = false

        scrollView.showsVerticalScrollIndicator = false
    }

}
