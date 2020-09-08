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
    private var recordTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.cornerRadius = 12
        table.layer.masksToBounds = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        table.separatorStyle = .none
        table.separatorColor = .clear
        table.allowsSelection = false
        return table
    }()
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        let safeArea = self.view.layoutMarginsGuide
        recordTable.delegate = self
        recordTable.dataSource = self
        recordTable.register(UINib(nibName: "RecordCell", bundle: nil), forCellReuseIdentifier: "RecordCell")
        
        self.view.backgroundColor =  UIColor(red: 247/255, green: 247/255, blue: 250/255, alpha: 1.0)
        self.view.addSubview(recordTable)
//        self.recordTable.estimatedSectionHeaderHeight = 9
//        self.recordTable.estimatedSectionFooterHeight = 9
        
        
        NSLayoutConstraint.activate([
            recordTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            recordTable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            recordTable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            recordTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension RecordVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordTable.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath as IndexPath) as! RecordCell
   
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count: CGFloat = 8
        return UIScreen.main.bounds.height / count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        return cell.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 250/255, alpha: 1.0)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}
