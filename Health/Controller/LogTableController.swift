//
//  LogViewController.swift
//  Health
//
//  Created by Geon Kang on 2020/07/24.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit
import RealmSwift

class LogTableController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topView: UIView!
    let realm = try! Realm()
    var resultTimeLog: Array<TimeLog>?
    let yesterday = Date()
    let timerAsset = TimerAssets()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        resultTimeLog = Array(realm.objects(TimeLog.self)).filter{ format.string(from: $0.dateTime) == format.string(from: Date()) }
        // 저장된 Realm을 배열로 선언하여 filter함수를 통해 사용자 당일의 날짜에 해당하는 DB만 표시되게 함
        
        self.tableView.reloadData()
    }
}

extension LogTableController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      
        var st = ""
        switch section {
        case 0:
           st = "ST"
        case 1:
            st = "ND"
        case 2:
            st = "RD"
        default:
            st = "TH"
        }

        return "\(section+1)" + st + " Round"
    }


    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.textAlignment = .left
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return resultTimeLog?.last?.roundCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredLog = resultTimeLog?.filter {
              $0.roundCount == section + 1
        }
        
        return filteredLog?.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogTableCell", for: indexPath) as! LogTableCell
        let filteredLog = resultTimeLog?.filter { $0.roundCount == indexPath.section + 1 }
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let workoutTime = filteredLog?[indexPath.row].workoutTime ?? 0
        let restTime = filteredLog?[indexPath.row].restTime ?? 0
        

        cell.logNumber.text = String(filteredLog?[indexPath.row].setCount ?? 0)
        cell.workoutTime.text = String(format: "%02d:%02d", workoutTime/60, workoutTime%60)
        cell.restTime.text = String(format: "%02d:%02d", restTime/60, restTime%60)
        cell.logTime.text = dateFormatter.string(from: filteredLog?[indexPath.row].dateTime ?? Date())

        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
}
