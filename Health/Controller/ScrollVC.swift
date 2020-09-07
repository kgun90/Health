//
//  PageVC.swift
//  Health
//
//  Created by Geon Kang on 2020/07/23.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class ScrollVC: UIPageViewController{
    
    let pageControl = UIPageControl()
    let settingImage = UIImage(systemName: "gear")
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        if let timerVC = VCArray.first {
            setViewControllers([timerVC], direction: .forward, animated: true, completion: nil)
        }
        let gearButton = UIBarButtonItem(image: settingImage, style: .plain, target: self, action: #selector(gearButtonAction))
        // action 을 통해 버튼 동작시 실행 함수를 부여함
        self.navigationItem.rightBarButtonItem = gearButton
        // Navigation bar 오른쪽 버튼 생성
        
        var appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = UIColor.red
        appearance.currentPageIndicatorTintColor = UIColor.red
        appearance.size(forNumberOfPages: 15)
    }
    
    @objc private func gearButtonAction(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showTimerSettingVC", sender: self)
        // Storyboard에서 Scroll -> TimerSettingVC Segue 를 설정하고 이를 버튼 동작으로 실행한다.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            (VCArray.first as! TimerVC).timerOff()
        }
        
    }
    lazy var VCArray: [UIViewController] = {
        return [self.VCInstance(name: "TimerVC"),
                self.VCInstance(name: "LogVC")]
    }()
}

extension ScrollVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArray.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard VCArray.count > previousIndex else {
            return nil
        }
        
        return VCArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArray.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VCArray.count else {
            return nil
        }
        
        guard VCArray.count > nextIndex else {
            return nil
        }
        
        return VCArray[nextIndex]
    }
 
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArray.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = VCArray.firstIndex(of: firstViewController) else {
            return 0
        }
        return firstViewControllerIndex
    }


    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: name)
    }
    
}


