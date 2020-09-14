//
//  TimerSettingVC.swift
//  Health
//
//  Created by Geon Kang on 2020/08/11.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit

class TimerSettingVC: UIViewController {
    
    @IBOutlet var viewLayout: [UIView]!
    @IBOutlet var pickerLayout: [UITextField]!
    
    @IBOutlet weak var countOptionSwitch: UISwitch!

    @IBOutlet weak var workoutTimeTextfield: UITextField!
    @IBOutlet weak var restTimeTextfield: UITextField!
    @IBOutlet weak var intervalTimeTextfield: UITextField!
    
    @IBOutlet weak var setTextfield: UITextField!
    @IBOutlet weak var roundTextfield: UITextField!
    
    @IBOutlet weak var workoutTimerTypeLabel: UILabel!
    @IBOutlet weak var workoutTimeLabel: UILabel!
    @IBOutlet weak var estTimeLabel: UILabel!
    
    var workoutTimePickerview = UIPickerView()
    var restTimePickerview = UIPickerView()
    var intervalTimePickerview = UIPickerView()
    var setPickerview = UIPickerView()
    var roundPickerview = UIPickerView()
    

    
    let disabledTextColor = UIColor(red: 69/255, green: 79/255, blue: 99/255, alpha: 0.4)
    let activeTextColor = UIColor(red: 69/255, green: 79/255, blue: 99/255, alpha: 1.0)
    

    let workoutTimeSet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let restTimeSet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let intervalTimeSet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let setCountSet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let roundCountSet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    
    var wtime = 0
    var rtime = 0
    var itime = 0
    var scount = 0
    var rcount = 0
    var timeResult = 0
    var countType = false
    
    let defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        viewLayout.forEach { $0.layer.cornerRadius = 12.0 }
        pickerLayout.forEach {
            $0.addRightPadding()
            $0.layer.cornerRadius = 8.0
        }
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        workoutTimeTextfield.backgroundColor = disabledTextColor

        countOptionSwitch.isOn = defaults.bool(forKey: "switchState")
        wtime = defaults.integer(forKey: "workoutTime")
        rtime = defaults.integer(forKey: "restTime")
        itime = defaults.integer(forKey: "intervalTime")
        scount = defaults.integer(forKey: "setCount")
        rcount = defaults.integer(forKey: "roundCount")
        
//        workoutTimeTextfiled.isUserInteractionEnabled = false

        countTypeChange()
        totalTime()
        
        workoutTimeTextfield.inputView = workoutTimePickerview
        restTimeTextfield.inputView = restTimePickerview
        intervalTimeTextfield.inputView = intervalTimePickerview
        setTextfield.inputView = setPickerview
        roundTextfield.inputView = roundPickerview
        
//        workoutTimeTextfiled.text = UserDefaults.standard.string(forKey: "workoutTime")

        workoutTimeTextfield.text = "\(wtime) min"
        restTimeTextfield.text = "\(rtime) min"
        intervalTimeTextfield.text = "\(itime) sec"
        setTextfield.text = "\(scount)"
        roundTextfield.text = "\(rcount)"
        
        workoutTimePickerview.delegate = self
        workoutTimePickerview.dataSource = self
        restTimePickerview.delegate = self
        restTimePickerview.dataSource = self
        intervalTimePickerview.delegate = self
        intervalTimePickerview.dataSource = self
        setPickerview.delegate = self
        setPickerview.dataSource = self
        roundPickerview.delegate = self
        roundPickerview.dataSource = self
        
        workoutTimePickerview.tag = 1
        restTimePickerview.tag = 2
        intervalTimePickerview.tag = 3
        setPickerview.tag = 4
        roundPickerview.tag = 5

    }

    
    @IBAction func timerStatusSwitch(_ sender: UISwitch) {
        saveSettings()
        // switch 동작 순간에 해당 값을 UserDefaults로 저장한다.
        countTypeChange()
        totalTime()
    }
    func countTypeChange() {
        switch countOptionSwitch.isOn {
        case true:
            workoutTimerTypeLabel.text = "Count Down"
            workoutTimeLabel.textColor = activeTextColor
            estTimeLabel.textColor = activeTextColor
            workoutTimeTextfield.isUserInteractionEnabled = true
            workoutTimeTextfield.backgroundColor = UIColor(red: 52/255, green: 151/255, blue: 253/255, alpha: 1.0)
       
        case false:
            workoutTimerTypeLabel.text = "Count Up"
            workoutTimeLabel.textColor = disabledTextColor
            estTimeLabel.textColor = disabledTextColor
            workoutTimeTextfield.isUserInteractionEnabled = false
            workoutTimeTextfield.backgroundColor = disabledTextColor
        }
    }
    
    func totalTime() {
        switch countOptionSwitch.isOn {
        case true:
            let totalTime = ((((wtime + rtime) * 60 * scount) + itime) * rcount) - itime
            timeResult = totalTime
            if totalTime > 3600 {
                let hrs = totalTime/3600
                let mins = totalTime - (hrs*3600)
                estTimeLabel.text = String(format: "%02d:%02d:%02d", hrs, mins/60, mins%60)
            } else {
                estTimeLabel.text = String(format: "%02d:%02d", totalTime/60, totalTime%60)
            }

        case false:
            estTimeLabel.text = "00:00"
        }
    }
    func saveSettings() {
        defaults.set(countOptionSwitch.isOn, forKey: "switchState")
        defaults.set(wtime, forKey: "workoutTime")
        defaults.set(rtime, forKey: "restTime")
        defaults.set(itime, forKey: "intervalTime")
        defaults.set(scount, forKey: "setCount")
        defaults.set(rcount, forKey: "roundCount")
        defaults.set(timeResult, forKey: "totalTime")
    }
    
}

extension TimerSettingVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // PickerView 내 몇개의 선택 가능한 리스트를 표시할 것인지 설정
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return workoutTimeSet.count
        case 2:
            return restTimeSet.count
        case 3:
            return intervalTimeSet.count
        case 4:
            return setCountSet.count
        case 5:
            return roundCountSet.count
        default:
            return 1
        }
    }
    // PickerView에 표시될 항목의 개수 반환
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return String(workoutTimeSet[row])
        case 2:
            return String(restTimeSet[row])
        case 3:
            return String(intervalTimeSet[row])
        case 4:
            return String(setCountSet[row])
        case 5:
            return String(roundCountSet[row])
        default:
            return "there is no data"
        }
        
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        switch pickerView.tag {
        case 1:
            workoutTimeTextfield.text = "\(workoutTimeSet[row]) min"
            workoutTimeTextfield.resignFirstResponder()
            wtime = workoutTimeSet[row]
        case 2:
            restTimeTextfield.text = "\(restTimeSet[row]) min"
            restTimeTextfield.resignFirstResponder()
            rtime = restTimeSet[row]
        case 3:
            intervalTimeTextfield.text = "\(intervalTimeSet[row]) sec"
            intervalTimeTextfield.resignFirstResponder()
            itime = intervalTimeSet[row]
        case 4:
            setTextfield.text = "\(setCountSet[row])"
            setTextfield.resignFirstResponder()
            scount = setCountSet[row]
        case 5:
            roundTextfield.text = "\(roundCountSet[row])"
            roundTextfield.resignFirstResponder()
            rcount = roundCountSet[row]
        default:
             return
        }
        totalTime()
        saveSettings()
    }
    


}
