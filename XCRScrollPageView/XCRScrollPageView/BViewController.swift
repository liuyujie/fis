//
//  BViewController.swift
//  XCRScrollPageView
//
//  Created by liuyujie on 2018/6/14.
//  Copyright © 2018年 塞纳德（北京）信息技术有限公司. All rights reserved.
//

import UIKit

class BViewController: UIViewController {

    var vcCanScroll : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64 - 44), style: .plain)
        tableView.scrollsToTop = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell_ID")
        
        view.addSubview(tableView)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension BViewController : UITableViewDataSource ,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_ID")
        cell?.textLabel?.text = "\(indexPath.row)_TOm"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.orange
        if let navVC = navigationController {
            navVC.pushViewController(vc, animated: true)
        } else {
            self.presentVC(vc)
        }
    }
    
}

extension BViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = scrollView.contentOffset.y
        
        if !self.vcCanScroll {
            scrollView.contentOffset = CGPoint.zero
        }
        
        if y <= 0 {
            self.vcCanScroll = false
            scrollView.contentOffset = CGPoint.zero
        }
    
        scrollView.showsVerticalScrollIndicator = self.vcCanScroll
    }
}

