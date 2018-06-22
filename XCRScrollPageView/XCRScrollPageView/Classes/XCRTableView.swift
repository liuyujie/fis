//
//  XCRTableView.swift
//  XCRScrollPageView
//
//  Created by Liuyujie on 2018/6/14.
//  Copyright © 2018年 塞纳德（北京）信息技术有限公司. All rights reserved.
//

import UIKit

class XCRTableView: UITableView , UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        print(gestureRecognizer.view)
        
        print(otherGestureRecognizer.view)
        return true
    }
    
}
