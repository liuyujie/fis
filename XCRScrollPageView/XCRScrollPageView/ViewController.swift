//
//  ViewController.swift
//  XCRScrollPageView
//
//  Created by liuyujie on 2018/6/14.
//  Copyright © 2018年 塞纳德（北京）信息技术有限公司. All rights reserved.
//

import UIKit
import XCRTitleScrollView

class ViewController: UIViewController {
        
    var viewCanScroll : Bool = true
    
    var tableView: UITableView!
    
    var scrollPageView: XCRScrollPageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        tableView = XCRTableView(frame: frame, style: .plain)
        tableView.isDirectionalLockEnabled = true
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
                let titleArray = ["abc","dbcc","db2cc","dbc3c","dbc2c","dbc2"]
                let childVCArray = [BViewController(),BViewController(),BViewController(),BViewController(),BViewController(),BViewController()]
                var style = XCRTitleScrollViewStyle()
                style.sideInset = 10
                style.selectedColor = UIColor.c1DA1F2
                style.normalColor = UIColor.cB5B8BB
                style.hideSeparateLine = false
                scrollPageView = XCRScrollPageView(frame: frame, titleStyle:style, titles: titleArray, childVCs:childVCArray , parentViewController: self);
                scrollPageView.pageDelegate = self
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
        
        let vc = self.scrollPageView.childVCArray[self.scrollPageView.selectIndex] as! BViewController

        
        if y >= 230 {
            self.tableView.contentOffset = CGPoint(x: 0, y: 230)
            if (self.viewCanScroll) {
                self.viewCanScroll = false;
                vc.vcCanScroll = true;
            }
        } else {
            if !self.viewCanScroll {//子视图没到顶部
                self.tableView.contentOffset = CGPoint(x: 0, y: 230)
            }
        }
        
        if !vc.vcCanScroll && !self.viewCanScroll {
            self.viewCanScroll = true
        }
        scrollView.showsVerticalScrollIndicator = false
        
        
        print(vc.vcCanScroll,self.viewCanScroll)
    }
    
}

extension ViewController : XCRScrollPageViewDelegate {
    

    func scrollPageViewWillBeginDragging(_ scrollView: UIScrollView){
        tableView.isScrollEnabled = false
    }
    
    func scrollPageViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
         tableView.isScrollEnabled = true
    }
    
}
