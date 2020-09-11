//
//  RecordVC.swift
//  Health
//
//  Created by Geon Kang on 2020/09/08.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit
import RealmSwift


class RecordVC: UIViewController {
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
    
    private var recordTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
       
        table.allowsSelection = false
        return table
    }()
    
    var recordResult = [TimeLog]()
    var resultSortedbyDate = [Date : [TimeLog]]()
    let screenHeight = UIScreen.main.bounds.height
    let realm = try! Realm()
    let textColor = UIColor(red: 69/255, green: 79/255, blue: 99/255, alpha: 1.0)
    
    struct recordData {
        var set = ""
        var round = ""
        var time = ""
        var workout = ""
        var rest = ""
        var date = ""
    }
    var recordLabels: [recordData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let safeArea = self.view.layoutMarginsGuide
        
      
        self.view.backgroundColor =  UIColor(red: 247/255, green: 247/255, blue: 250/255, alpha: 1.0)
        
        self.view.addSubview(topView)
        self.view.addSubview(recordTable)
        self.topView.addSubview(titleLabel)
  
        titleLabel.textColor = textColor
        titleLabel.font = UIFont(name: "Jost*", size: 40.0)
        titleLabel.text = "Statistics"
        titleLabel.backgroundColor = .clear
        
        recordTable.separatorStyle = .none
        recordTable.backgroundColor = .clear
        recordTable.layer.cornerRadius = 12
        recordTable.layer.masksToBounds = true
        recordTable.delegate = self
        recordTable.dataSource = self
        recordTable.register(UINib(nibName: "RecordCell", bundle: nil), forCellReuseIdentifier: "RecordCell")
            
        recordResult = Array(realm.objects(TimeLog.self))
        print(recordResult)

        resultSortedbyDate = Dictionary(grouping: recordResult, by:  { $0.workoutSeq })
        let order = resultSortedbyDate.sorted() { $0.0 < $1.0}
        
     
        order.forEach { seq in
            let workoutTotal = seq.1.reduce(0) { $0 + $1.workoutTime }
            let restTotal = seq.1.reduce(0){ $0 + $1.restTime }
            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "yy.MM.dd HH:mm:ss"
            recordLabels.append(recordData(
                set: "\(seq.value.last?.setCount ?? 0)",
                round: "\(seq.value.last?.roundCount ?? 0)",
                time: String(format: "%02d:%02d", (workoutTotal+restTotal)/60, (workoutTotal+restTotal) % 60),
                workout: String(format: "%02d", workoutTotal),
                rest: String(format: "%02d", restTotal),
                date: String(timeFormat.string(from: seq.key))
            ))
            
        }

        
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: screenHeight * 0.19)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 84),
        ])
        
        NSLayoutConstraint.activate([
            recordTable.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: screenHeight * 0.075),
            recordTable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            recordTable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            recordTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension RecordVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSortedbyDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordTable.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath as IndexPath) as! RecordCell
       
        cell.setLabel.text = recordLabels[indexPath.row].set
        cell.roundLabel.text = recordLabels[indexPath.row].round
        cell.totalTimeLabel.text = recordLabels[indexPath.row].time
        cell.totalWorkoutLabel.text = recordLabels[indexPath.row].workout
        cell.totalRestLabel.text = recordLabels[indexPath.row].rest
        cell.recordTimeLabel.text = recordLabels[indexPath.row].date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight * 0.16
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        return cell.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 250/255, alpha: 1.0)
    }
    

      
 
}
