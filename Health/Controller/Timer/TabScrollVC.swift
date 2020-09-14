//
//  TabScrollVC.swift
//  Health
//
//  Created by Geon Kang on 2020/09/02.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class TabScrollVC: TabmanViewController {
    private var viewControllers: Array<UIViewController> = []
    private let settingImage = UIImage(systemName: "gear")
    
    @IBOutlet weak var paddingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimerVC") as! TimerVC
        let logVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogVC") as! LogVC
        
        viewControllers.append(timerVC)
        viewControllers.append(logVC)
        
        self.dataSource = self
        
        (viewControllers[0] as! TimerVC).delegate = viewControllers[1].self as? TimerDataDelegate
        // LogVC에서 작성 된 delegate를 TimerVC에서 데이터를 전달 받고, Delegate를 부여함
        
        paddingView.layer.cornerRadius = 12.0
        
        let bar = TMBar.LineBar()
     
        bar.indicator.cornerStyle = .rounded
        bar.indicator.tintColor = UIColor(red: 58/255, green: 204/255, blue: 225/255, alpha: 1.0)

        bar.backgroundColor = UIColor(red: 69/255, green: 79/255, blue: 99/255, alpha: 1.0)
        bar.indicator.weight = .custom(value: 6.0)
    
        addBar(bar, dataSource: self, at: .custom(view: paddingView, layout: nil))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let gearButton = UIBarButtonItem(image: settingImage, style: .plain, target: self, action: #selector(gearButtonAction))
        // action 을 통해 버튼 동작시 실행 함수를 부여함
        self.navigationItem.rightBarButtonItem = gearButton
        // Navigation bar 오른쪽 버튼 생성
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
           (viewControllers[0] as! TimerVC) .timerOff()
        }
        
    }
    @objc private func gearButtonAction(sender: UIBarButtonItem) {
          self.performSegue(withIdentifier: "showTimerSettingVC", sender: self)
          // Storyboard에서 Scroll -> TimerSettingVC Segue 를 설정하고 이를 버튼 동작으로 실행한다.
      }
    deinit {
        print("TabScrollVC Deinit")
    }
}
extension TabScrollVC: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
            let item = TMBarItem(title:"")
            
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
