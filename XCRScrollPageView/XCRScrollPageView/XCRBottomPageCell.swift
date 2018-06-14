//
//  XCRBottomPageCell.swift
//  XCRScrollPageView
//
//  Created by Liuyujie on 2018/6/14.
//  Copyright © 2018年 塞纳德（北京）信息技术有限公司. All rights reserved.
//

import UIKit

class XCRBottomPageCell: UITableViewCell {
    
    var scrolPageView : XCRScrollPageView?
    var cellCanScroll : Bool = false
    var isRefresh : Bool = false
    var selectedTitle : String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
