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
    let realm = try! Realm()
    var resultTimeLog: Array<TimeLog>?
    let yesterday = Date()
    
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultTimeLog?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogTableCell", for: indexPath) as! LogTableCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let workoutTime = resultTimeLog?[indexPath.row].workoutTime ?? 0
        let restTime = resultTimeLog?[indexPath.row].restTime ?? 0
        
        cell.logNumber.text = String(indexPath.row + 1)
        cell.workoutTime.text = String(format: "운동: %02d:%02d", workoutTime/60, workoutTime%60)
        cell.restTime.text = String(format: "휴식: %02d:%02d", restTime/60, restTime%60)
        cell.logTime.text = dateFormatter.string(from: resultTimeLog?[indexPath.row].dateTime ?? Date())
        
        return cell
    }
    
    
}
