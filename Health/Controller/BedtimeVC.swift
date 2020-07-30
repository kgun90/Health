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
  
    @IBOutlet weak var resultTimeStack: UIStackView!
    
    enum sleepAndWake {
        case sleep
        case wake
    }
    let datePicker = UIDatePicker()
    var sleepSignal: sleepAndWake?
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var component = DateComponents()
        component.hour = 7
        component.minute = 0
        let calendar = Calendar.current
        
        
        
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.minuteInterval = 5
        datePicker.date = calendar.date(from: component)!
        

        
        timeSelect.text = formatter.string(from: datePicker.date)
        sleepSignal = sleepAndWake.sleep
        
        createPickerView()
        changeStatus(sleepSignal ?? sleepAndWake.sleep,  calculateSleepTime(datePicker.date, sleepSignal ?? sleepAndWake.sleep))
        
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
        
        switch sleepAndWake {
        case .sleep:
            for i in 3 ... 5 {
                resultTime?.append(Date(timeInterval: -TimeInterval(5400*i), since: pickedTime))
            }
          
            print("sleep")
        case .wake:
            for j in 4 ... 6 {
                resultTime?.append(Date(timeInterval: TimeInterval(5400*j), since: pickedTime))
            }
            print("wake")
        }
        return resultTime!
    }

    
    func changeStatus(_ status: sleepAndWake, _ resultTime: [Date]) {
        var titleLabel = ""
        var placeholderLabel = ""
        var aboveLabel = ""
        var underLabel = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        switch status {
            case .sleep:
                titleLabel = "잠 들 시간"
                placeholderLabel = "일어 날 시간 선택"
                aboveLabel = "이 시간에 일어나려면"
                underLabel = "이 시간에 자야 합니다."
                
            case .wake:
                titleLabel = "일어날 시간"
                placeholderLabel = "잠 잘 시간 선택"
                aboveLabel = "이 시간에 잠들면"
                underLabel = "이 시간에 일어나야 합니다."
        }
        
        self.titleLabel.text = titleLabel
        self.aboveLabel.text = aboveLabel
        self.underLabel.text = underLabel
        self.timeSelect.placeholder = placeholderLabel
        
        for i in 0 ..< resultTime.count {
            (self.resultTimeStack.subviews[i] as! UILabel).text = formatter.string(from: resultTime[i])
        }
       
    }
    
}
// 기상시간 계산 현재시간 기준 설정시간 - 90min * 3/4/5
// 취침시간 계산 설정시간 기준 설정시간 + 90min * 4/5/6
