//
//  ViewController.swift
//  Health
//
//  Created by Geon Kang on 2020/07/21.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var statisticButton: UIButton!
    @IBOutlet weak var bedtimeButton: UIButton!
    
    @IBOutlet var menuButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        menuButtons.forEach { $0.layer.cornerRadius = 8}
      

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
         self.setNavigationBar()
    }
    func setNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Back button text 제거
        self.navigationController?.hidesBarsOnSwipe = false
        // 위로 스와이프 동작시 네비게이션 버튼이 위로 올라가는것을 해제함
        let bar: UINavigationBar! = self.navigationController?.navigationBar
 
        
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = .clear
        
        
    }

}

