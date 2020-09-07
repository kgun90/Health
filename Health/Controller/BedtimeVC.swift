//
//  BedtimeVC.swift
//  Health
//
//  Created by Geon Kang on 2020/07/29.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit

class BedtimeVC: UIViewController {
    @IBOutlet weak var timeSelect: UITextField!
    @IBOutlet weak var sleepAndWakeSegment: UISegmentedControl!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var aboveLabel: UILabel!
    @IBOutlet weak var underLabel: UILabel!
    
    @IBOutlet var timeResultLabels: [UILabel]!
    @IBOutlet var timeLabelsBackground: [UIView]!
    @IBOutlet weak var topViewBackground: UIView!
    
    
    enum sleepAndWake {
        case sleep
        case wake
    }

    struct colors {
        let sleepBackground     = UIColor(red:  42/255, green:  46/255, blue:   67/255, alpha: 1.0)
        let sleepTextBackground = UIColor(red:  53/255, green:  58/255, blue:   80/255, alpha: 1.0)
        let sleepText           = UIColor(red: 255/255, green: 255/255, blue:  255/255, alpha: 1.0)
        let wakeBackground      = UIColor(red: 245/255, green: 245/255, blue:  255/255, alpha: 1.0)
        let wakeTextBackground  = UIColor(red: 255/255, green: 255/255, blue:  255/255, alpha: 1.0)
        let wakeText            = UIColor(red:  42/255, green:  46/255, blue:   67/255, alpha: 1.0)
    }
    
    let datePicker = UIDatePicker()
    var sleepSignal: sleepAndWake?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
       
        var component = DateComponents()
        let calendar = Calendar.current
        
        component.hour = 7
        component.minute = 0
        
        
        datePicker.locale = Locale(identifier: "en_GB")
        // 24시간 표시 설정
        datePicker.minuteInterval = 5
        // datepicker 5분단위 표시 설정
        datePicker.date = calendar.date(from: component)!
        
  
        timeSelect.text = formatter.string(from: datePicker.date)
        sleepSignal = sleepAndWake.sleep
        
        createPickerView()
        changeStatus(sleepSignal ?? sleepAndWake.sleep,  calculateSleepTime(datePicker.date, sleepSignal ?? sleepAndWake.sleep))
        
        sleepAndWakeSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        sleepAndWakeSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: UIControl.State.normal)
        // segment 내 요소 (달, 해 모양의 SF symbol image)색상 변경을 위한 코드, UIControl.State.~의 상태에 따라 다르게 색상을 지정했으며, 선택되지 않은 상태는 normal로 정의하여 사용한다.

 
  
        
    }
    @IBAction func segmentChanged(_ sender: Any) {
        if sleepAndWakeSegment.selectedSegmentIndex == 0 {
            sleepSignal = sleepAndWake.sleep
        }  else {
            sleepSignal = sleepAndWake.wake
        }
       
        changeStatus(sleepSignal ?? sleepAndWake.sleep,  calculateSleepTime(datePicker.date, sleepSignal ?? sleepAndWake.sleep))
        
    }
    func createPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
       
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPickerView))
        toolBar.setItems([doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true

        timeSelect.inputView = datePicker
        timeSelect.inputAccessoryView = toolBar
        datePicker.datePickerMode = .time
        
    }
    
    @objc func dismissPickerView() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        self.view.endEditing(true)
        timeSelect.text = "\(formatter.string(from: datePicker.date))"
       
        changeStatus(sleepSignal ?? sleepAndWake.sleep,  calculateSleepTime(datePicker.date, sleepSignal ?? sleepAndWake.sleep))
       
    }
    
    func calculateSleepTime(_ pickedTime: Date, _ sleepAndWake: sleepAndWake) -> [Date] {
        var resultTime: [Date]? = []
        // 기상시간 계산 현재시간 기준 설정시간 - 90min * 3/4/5
        // 취침시간 계산 설정시간 기준 설정시간 + 90min * 4/5/6

        switch sleepAndWake {
            case .sleep:
                for i in 3 ... 5 {
                    resultTime?.append(Date(timeInterval: -TimeInterval(5400*i), since: pickedTime))
                }
            case .wake:
                for j in 4 ... 6 {
                    resultTime?.append(Date(timeInterval: TimeInterval(5400*j), since: pickedTime))
                }
        }

        return resultTime!
    }

    
    func changeStatus(_ status: sleepAndWake, _ resultTime: [Date]) {
        var titleLabel = ""
        var placeholderLabel = ""
        var topLabel = ""
        var bottomLabel = ""
        
        var backgroundColor = UIColor()
        var textColor = UIColor()
        var textBackgroundColor = UIColor()
        
        let allColors = colors()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        switch status {
            case .sleep:
                titleLabel = "Bedtime"
                placeholderLabel = "Select Time"
                topLabel = "Select the time you want to wake up"
                bottomLabel = "We recommend the time below for best sleep quality."
                
                backgroundColor = allColors.sleepBackground
                textColor = allColors.sleepText
                textBackgroundColor = allColors.sleepTextBackground
                
            case .wake:
                titleLabel = "Rise & Shine"
                placeholderLabel = "Select Time"
                topLabel = "Select the time you want to get sleep"
                bottomLabel = "We recommend the time below for best sleep quality."
                
                backgroundColor = allColors.wakeBackground
                textBackgroundColor = allColors.wakeTextBackground
                textColor = allColors.wakeText
        }
        
        self.titleLabel.text = titleLabel
        self.aboveLabel.text = topLabel
        self.underLabel.text = bottomLabel
        
        self.titleLabel.textColor = textColor
        self.aboveLabel.textColor = textColor
        self.underLabel.textColor = textColor
        
        self.timeLabelsBackground.forEach {
            $0.backgroundColor = textBackgroundColor
            $0.layer.cornerRadius = 8
        }
        self.topViewBackground.backgroundColor = textBackgroundColor
    
        
        
        self.view.backgroundColor = backgroundColor
        
        self.timeSelect.placeholder = placeholderLabel
        self.timeSelect.textColor = textColor
        
    
        
        for i in 0 ..< timeResultLabels.count {
            self.timeResultLabels[i].text = formatter.string(from: resultTime[i])
            self.timeResultLabels[i].textColor = textColor
        }
       
    }
    
}
