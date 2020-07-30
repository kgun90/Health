//
//  WorkoutLogVC.swift
//  Health
//
//  Created by Geon Kang on 2020/07/25.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class TotalLogVC: UIViewController, IValueFormatter{
     
    let realm = try! Realm()
    
    var selectedDate = Date()
    let dateFormatter = DateFormatter()

    @IBOutlet weak var dataTF: UITextField!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var datePickerPreview: UITextField!
    
    let datePicker = UIDatePicker()
    
    var logData: Array<TimeLog>?
    var pickerDate: Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        logData = Array(realm.objects(TimeLog.self))
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var tmpArray: [String] = []
        logData!.forEach {
            tmpArray.append(dateFormatter.string(from: $0.dateTime))
        }
        tmpArray.map { if !pickerDate.contains($0) { pickerDate.append($0)}}
                
        createPickerView()
        workoutChart(dateFormatter.string(from: Date()))
        
    }

    func workoutChart(_ selectedDate: String) {
        var workoutBarChartEntry = [BarChartDataEntry]()
        var dateLabel: [String] = []
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm"
    
        
        logData?.filter { dateFormatter.string(from: $0.dateTime) == selectedDate }.forEach({
            let work = [Double($0.workoutTime), Double($0.restTime)]
            let workoutSpendValue = BarChartDataEntry(x: Double(dateLabel.count), yValues: work)
            
            workoutBarChartEntry.append(workoutSpendValue)
            
            dateLabel.append("\($0.setCount)세트")
       
        })

        let workoutDataSet = BarChartDataSet(entries: workoutBarChartEntry, label: nil)
        let chartData = BarChartData()
        
        workoutDataSet.stackLabels = ["workout", "rest"]
        workoutDataSet.valueFont = UIFont(name: "Futura", size: 15.0)!
        workoutDataSet.colors = [NSUIColor.blue, NSUIColor.systemPink]
        workoutDataSet.valueFormatter = self
        
     
        chartData.addDataSet(workoutDataSet)
        chartData.setDrawValues(true)
        
        chartView.legend.verticalAlignment = .top
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateLabel)
//        chartView.xAxis.setLabelCount(dateLabel, force: true)
        chartView.leftAxis.axisMinimum = 0.0
        // 바 그래프 아래로 붙이기 왼쪽 xaxis조정
        chartView.rightAxis.enabled = false
        // 오른쪽 xaxis 제거
        chartView.xAxis.labelPosition = .bottom
        // label 표시 위치 설정
        
        chartView.xAxis.granularity = 1
        chartView.xAxis.granularityEnabled = true
        // xAxis label 항목별 표시 옵션
        
        chartView.xAxis.drawGridLinesEnabled = false

        chartView.data = chartData
    }
    
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String{
        if value > 60 {
            return "\(Int(value)/60)분\(Int(value)%60)초"
        }
        return "\(Int(value))초"
    }
}

extension TotalLogVC: UIPickerViewDelegate, UIPickerViewDataSource {
 

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        // 선택 가능한 리스트의 개수를 반환함, 몇개의 선택 가능한 리스트를 표시할것인가
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDate.count
        // pickerview에 표시될 항목의 개수를 반환하는 메서드
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerDate[row]
        // PickerView내 특정 위치(row)선택 시 그위치에 해당하는 문자열 반환 메서드
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        datePickerPreview.text = pickerDate[row]
        workoutChart(pickerDate[row])
        
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        datePickerPreview.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPickerView))
        toolBar.setItems([doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        datePickerPreview.inputAccessoryView = toolBar
           
    }
    @objc func dismissPickerView() {
        self.view.endEditing(true)
       
    }
}
