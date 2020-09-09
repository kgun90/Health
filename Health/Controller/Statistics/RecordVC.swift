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
   
    let screenHeight = UIScreen.main.bounds.height
    private let tabView = UIView()
    let realm = try! Realm()
    let textColor = UIColor(red: 69/255, green: 79/255, blue: 99/255, alpha: 1.0)
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
            recordTable.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 62),
            recordTable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            recordTable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            recordTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension RecordVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordTable.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath as IndexPath) as! RecordCell
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight * 0.16
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        return cell.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 250/255, alpha: 1.0)
    }
    

      
 
}
