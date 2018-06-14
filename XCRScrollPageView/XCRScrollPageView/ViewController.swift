//
//  ViewController.swift
//  XCRScrollPageView
//
//  Created by liuyujie on 2018/6/14.
//  Copyright © 2018年 塞纳德（北京）信息技术有限公司. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var vcCanScroll : Bool = false {
        didSet {
            if let vc = scrollPageView.childVCArray[scrollPageView.selectIndex] as? BViewController {
                vc.vcCanScroll = vcCanScroll
            }
        }
    }
    var tableView: UITableView!
    
    var scrollPageView: XCRScrollPageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        tableView = XCRTableView(frame: frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController : UITableViewDataSource ,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL_1")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "CELL_1")
                cell?.textLabel?.text = "header"
                cell?.contentView.backgroundColor = UIColor.purple
            }
            return cell!
        default:
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL_Page_View")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "CELL_Page_View")
                let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
                scrollPageView = XCRScrollPageView(frame: frame, titleStyle: XCRPageTitleStyle(), titles: ["abc","dbcc"], childVCs: [BViewController(),BViewController()], parentViewController: self);
                cell?.contentView.addSubview(scrollPageView)
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 230
        default:
            return UIScreen.main.bounds.height - 64
        }
    }
    
}

extension ViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y < 0 {
            self.tableView.contentOffset = CGPoint.zero
            self.vcCanScroll = true
        }
        
        if y < 230 {
            self.vcCanScroll = false
        } else {
            self.tableView.contentOffset = CGPoint(x: 0, y: 230)
            self.vcCanScroll = true
        }
        
        scrollView.showsVerticalScrollIndicator = false
    }
}

