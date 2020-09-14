//
//  newChartVC.swift
//  Health
//
//  Created by Geon Kang on 2020/09/11.
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
    
    private let recordView: UITableView = {
        let table =  UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.allowsSelection = false
        return table
    }()
    
    struct recordData {
        var set = ""
        var round = ""
        var time = ""
        var workout = ""
        var rest = ""
        var date = ""
    }
    private var recordLabels: [recordData] = []
    
    let realm = try! Realm()
    var statsResult = [TimeLog]()
    var chartView = BarChartView()
    private let paddingView = UIView()
   
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    override func viewDidLoad() {
        super.viewDidLoad()
        let safeArea = self.view.layoutMarginsGuide

        self.view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 250/255, alpha: 1.0)
        chartView.delegate = self
        chartView.backgroundColor = .white
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.layer.cornerRadius = 12
        
        paddingView.layer.cornerRadius = 12
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        paddingView.backgroundColor = .white
        
        recordView.separatorStyle = .none
        recordView.backgroundColor = .white
        recordView.layer.cornerRadius = 12
        recordView.layer.masksToBounds = true
        recordView.isScrollEnabled = false
        recordView.delegate = self
        recordView.dataSource = self
        recordView.register(UINib(nibName: "RecordCell", bundle: nil), forCellReuseIdentifier: "RecordCell")
        
        self.view.addSubview(topView)
        self.topView.addSubview(titleLabel)
        self.view.addSubview(paddingView)
        self.paddingView.addSubview(chartView)
        self.view.addSubview(recordView)

        
        titleLabel.font = UIFont(name: "Jost-Medium", size: 40)
        titleLabel.text = "Statistics"
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.19)
        ])
        
        NSLayoutConstraint.activate([
              titleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 24),
              titleLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 84),
        ])
        
        NSLayoutConstraint.activate([
            paddingView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: screenHeight * 0.08),
            paddingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            paddingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(screenHeight * 0.21))
        ])
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 20 ),
            chartView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 10),
            chartView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -10),
            chartView.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor, constant: -30)
        ])

        NSLayoutConstraint.activate([
            recordView.topAnchor.constraint(equalTo: paddingView.bottomAnchor, constant: 8 ),
            recordView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            recordView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            recordView.heightAnchor.constraint(equalToConstant: screenHeight * 0.16)
        ])

        drawChart()
    }
    func drawChart() {
        statsResult = Array(realm.objects(TimeLog.self))
        let statsOrdered = Dictionary(grouping: statsResult, by: { $0.workoutSeq })
        let statsData = statsOrdered.sorted() { $0.0 < $1.0 }
        
        var chartEntry = [BarChartDataEntry]()
        var dateLabel: [String] = []
        
        statsData.forEach { seq in
            let workoutTotal = seq.1.reduce(0) { $0 + $1.workoutTime }
            let restTotal = seq.1.reduce(0) { $0 + $1.restTime }
            
  
            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "MM.dd HH:mm"
            
            let totalChart = [Double(workoutTotal), Double(restTotal)]
            let chartSpendValue = BarChartDataEntry(x: Double(dateLabel.count), yValues: totalChart)
            
            chartEntry.append(chartSpendValue)
            
            dateLabel.append(timeFormat.string(from: seq.key))
            
            recordLabels.append(recordData(
                     set: "\(seq.value.last?.setCount ?? 0)",
                     round: "\(seq.value.last?.roundCount ?? 0)",
                     time: String(format: "%02d:%02d", (workoutTotal+restTotal)/60, (workoutTotal+restTotal) % 60),
                     workout: String(format: "%02d", workoutTotal),
                     rest: String(format: "%02d", restTotal),
                     date: String(timeFormat.string(from: seq.key))
                 ))
            
        }
        
        let chartDataSet = BarChartDataSet(entries: chartEntry, label: nil)
        let chartData = BarChartData()
        
        chartDataSet.stackLabels = ["workout", "rest"]
        chartDataSet.valueFont = UIFont(name: "Jost*", size: 15.0)!
        chartDataSet.colors = [UIColor(red: 2/255, green: 125/255, blue: 250/255, alpha: 1), UIColor(red: 119/255, green: 221/255, blue: 119/255, alpha: 1)]
        chartDataSet.valueFormatter = self
  
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true)
        chartData.barWidth = Double(0.3)
        
//        BarChartRenderer
        chartView.doubleTapToZoomEnabled = false
        chartView.legend.verticalAlignment = .top
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateLabel)
        chartView.xAxis.labelFont = UIFont(name: "Jost*", size: 8)!
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
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
//        if value > 60 {
//             return "\(Int(value)/60)분\(Int(value)%60)초"
//         }
//         return "\(Int(value))초"
        return ""
    }
     var selectedBar: Int = 0
}

extension StatsVC: ChartViewDelegate {
   
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        selectedBar = Int(highlight.x)
        self.recordView.reloadData()
        print(selectedBar)
    }
}
extension StatsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath as IndexPath) as! RecordCell
        cell.setLabel.text = recordLabels[selectedBar].set
        cell.roundLabel.text = recordLabels[selectedBar].round
        cell.totalTimeLabel.text = recordLabels[selectedBar].time
        cell.totalWorkoutLabel.text = recordLabels[selectedBar].workout
        cell.totalRestLabel.text = recordLabels[selectedBar].rest
        cell.recordTimeLabel.text = recordLabels[selectedBar].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight * 0.15
    }
}
