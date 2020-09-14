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
    @IBOutlet weak var paddingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let recordVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecordVC") as! RecordVC
        let statsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StatsVC") as! StatsVC
        
        
        viewControllers.append(recordVC)
        viewControllers.append(statsVC)
        
        self.dataSource = self


        
        let bar = TMBar.ButtonBar()
        let systemBar = bar.systemBar()
        bar.layout.contentMode = .fit
        bar.layout.alignment = .centerDistributed
    
        bar.backgroundColor = .white
        bar.buttons.customize {
            $0.font = UIFont(name: "Jost*", size: 13)!
            $0.tintColor = UIColor(red: 149/255, green: 157/255, blue: 173/255, alpha: 1.0)
       
        }
 
        systemBar.backgroundStyle = .clear//.blur(style: .light)
        addBar(systemBar, dataSource: self, at: .custom(view: paddingView, layout: nil))
        
        
    }
    
    
}

extension StatisticsVC: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var menu = ""
        
        switch index {
        case 0:
           menu = "RECORD"
        case 1:
            menu = "STATS"
        default:
            menu = ""
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
