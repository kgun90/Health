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

class StatsVC: UIViewController, IValueFormatter{
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    let realm = try! Realm()
       
    let dateFormatter = DateFormatter()

    @IBOutlet weak var chartView: BarChartView!
        
    var logData: Array<TimeLog>?
    var pickerDate: Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        

        logData = Array(realm.objects(TimeLog.self))
    
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
            
            dateLabel.append("\($0.dateTime)")
       
        })

        let workoutDataSet = BarChartDataSet(entries: workoutBarChartEntry, label: nil)
        let chartData = BarChartData()
        
        workoutDataSet.stackLabels = ["workout", "rest"]
        workoutDataSet.valueFont = UIFont(name: "Jost*", size: 15.0)!
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
