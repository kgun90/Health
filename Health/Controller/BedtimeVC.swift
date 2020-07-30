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
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var aboveLabel: UILabel!
    @IBOutlet weak var underLabel: UILabel!
    
    enum sleepAndWake {
        case sleep
        case wake
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.minuteInterval = 5
        datePicker.date = Date()
        
        createPickerView()
        
    }
    @IBAction func segmentChanged(_ sender: Any) {
        var titleLabel = ""
        var placeholderLabel = ""
        var aboveLabel = ""
        var underLabel = ""
        var sleepSignal: sleepAndWake?
//        var resultTime: [Date] = calculateSleepTime(datePicker.date)
        
        switch sleepAndWakeSegment.selectedSegmentIndex {
        case 0:
            titleLabel = "잠 들 시간"
            placeholderLabel = "일어 날 시간 선택"
            aboveLabel = "이 시간에 일어나려면"
            underLabel = "이 시간에 자야 합니다."
            sleepSignal = sleepAndWake.sleep
        case 1:
            titleLabel = "일어날 시간"
            placeholderLabel = "잠 잘 시간 선택"
            aboveLabel = "이 시간에 잠들면"
            underLabel = "이 시간에 일어나야 합니다."
            sleepSignal = sleepAndWake.wake
        default:
            return
        }
        self.titleLabel.text = titleLabel
        self.aboveLabel.text = aboveLabel
        self.underLabel.text = underLabel
        self.timeSelect.placeholder = placeholderLabel
        
        print(calculateSleepTime(datePicker.date, sleepSignal ?? sleepAndWake.sleep))
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
        print( calculateSleepTime(datePicker.date, sleepAndWake.sleep))
        
       
    }
    func calculateSleepTime(_ pickedTime: Date, _ sleepAndWake: sleepAndWake) -> [Date] {
        var sleepTime: Date?
        var wakeTime: Date?
        var resultTimes: [Date]?
        
        switch sleepAndWake {
        case .sleep:
            for i in 3 ... 5 {
                resultTimes?.append(Date(timeInterval: TimeInterval(3600 * i), since: pickedTime))
            }
        case .wake:
            for i in 4 ... 6 {
               resultTimes?.append(Date(timeInterval: TimeInterval(3600 * i), since: pickedTime))
           }
        default:
            for i in 3 ... 5 {
                resultTimes?.append(Date(timeInterval: TimeInterval(3600 * i), since: pickedTime))
            }
        }
        
        
        return resultTimes!
    }
    
    
}
// 기상시간 계산 현재시간 기준 설정시간 - 90min * 3/4/5
// 취침시간 계산 설정시간 기준 설정시간 + 90min * 4/5/6
