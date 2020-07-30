//
//  TimerViewController.swift
//  Health
//
//  Created by Geon Kang on 2020/07/22.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit
import RealmSwift

class TimerVC: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timerStart: UIButton!
    @IBOutlet weak var timerEnd: UIButton!
    @IBOutlet weak var restStart: UIButton!
    @IBOutlet weak var restTimeSetting: UITextField!
    @IBOutlet weak var setCountLabel: UILabel!
    
    var mTimer: Timer?
    var time: Int = 0
    let restTimes: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    let now = Date()
    let realm = try! Realm()
    
    var restTime = 60
    var setCount = 1
    
    var tmpTime: Int?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        restStart.isEnabled = false
        createPickerView()
    }
    
    @IBAction func onTimerStart(_ sender: Any) {
        btnSwitch()
       
        if mTimer != nil {
            createDB()
        }
        initTimer()
        mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
         timeLabel.text = timeDisplay(time)
    }
    
    
    @IBAction func onRestStart(_ sender: Any) {
        tmpTime = time
        btnSwitch()
        initTimer()
        mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCountdown), userInfo: nil, repeats: true)
        timeLabel.text = timeDisplay(restTime)
    }
    
    @IBAction func deleteDB(_ sender: Any) {
        try! realm.write({
            realm.deleteAll()
        })
    }
    @IBAction func onTimerEnd(_ sender: Any) {
//        tmpTime = time
//        btnSwitch()
//        createDB()
//        initTimer()
        
    }
    
    @objc func timerCallback() {
        time += 5
        timeLabel.text = timeDisplay(time)
    }
    
    @objc func timerCountdown() {
        if time > 0 {
            time -= 5
        } else {
            
        }
        timeLabel.text = timeDisplay(time)
    }
    
    func timeDisplay(_ number: Int) -> String {
        return String(format: "%02d:%02d", number/60, number%60)
    }
    
    func btnSwitch() {
        if mTimer?.isValid ?? false {
            mTimer?.invalidate()
        }
        timerStart.isEnabled = !timerStart.isEnabled
        restStart.isEnabled = !restStart.isEnabled
    }
    func saveData() -> TimeLog {
        let timeLog = TimeLog()
        print(time)
        timeLog.workoutTime = tmpTime ?? 0
        timeLog.restTime = restTime - time
        timeLog.dateTime = now
        timeLog.setCount = setCount
        
        return timeLog
    }
    func createDB(){

        
        do {
            try realm.write{
                realm.add(saveData())
            }
        } catch {
            print("ERRPORRRRRRR")
        }
        setCount += 1
        setCountLabel.text = "\(setCount) 세트"
    }
    func initTimer() {
        
        if !timerStart.isEnabled {
            time = 0
        } else {
            time = restTime
        }
        
//        timerStart.isEnabled ? time = 0 : time = restTime
    }
}

extension TimerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return restTimes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          
        return String(restTimes[row])
        // PickerView내 특정 위치(row)선택 시 그위치에 해당하는 문자열 반환 메서드
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        restTimeSetting.text = "휴식시간: \(restTimes[row])"
        restTime = restTimes[row] * restTime
      
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        restTimeSetting.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPickerView))
        toolBar.setItems([doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        restTimeSetting.inputAccessoryView = toolBar
    }
    @objc func dismissPickerView() {
        self.view.endEditing(true)
        
    }
}
