//
//  StatisticsVC.swift
//  Health
//
//  Created by Geon Kang on 2020/09/08.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class StatisticsVC: TabmanViewController {
    private var viewControllers: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recordVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecordVC") as! RecordVC
        let statsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StatsVC") as! StatsVC
        
        viewControllers.append(recordVC)
        viewControllers.append(statsVC)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.contentMode = .fit
        bar.layout.alignment = .centerDistributed

        addBar(bar, dataSource: self, at: .top)
        
    }
    
    
}

extension StatisticsVC: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var menu = ""
        if index == 0 {
              menu = "RECORD"
        } else {
              menu = "STATS"
        }
       
        let item = TMBarItem(title: menu)
        return item
    }
    
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    
}
