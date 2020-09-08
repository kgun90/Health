//
//  LogTableTest.swift
//  Health
//
//  Created by Geon Kang on 2020/09/03.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit
import RealmSwift


class LogVC: UIViewController, TimerDataDelegate{
    
    let realm = try! Realm()
    var resultTimeLog = [TimeLog]()

    
    
    private var myTableView: UITableView = {
       let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tv.layer.cornerRadius = 10
        tv.layer.masksToBounds = true
        
        return tv
    }()
 
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    


    let screenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let safeArea = self.view.layoutMarginsGuide
        let title: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .white//UIColor(red: 69/255, green: 79/255, blue: 99/255, alpha: 1.0)
            label.font = UIFont(name: "Jost* ", size: 40.0)
            label.text = "Log"
            label.backgroundColor = .blue
            return label
        }()

        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyTableViewCell")
       
       
        self.view.addSubview(myTableView)
        self.view.addSubview(topView)
        self.topView.addSubview(title)
        
       

        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topView.topAnchor.constraint(equalTo: self.view.topAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: screenHeight * 0.2)
        ])
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            title.topAnchor.constraint(equalTo: topView.topAnchor),
            title.widthAnchor.constraint(equalToConstant: 200),
            title.bottomAnchor.constraint(equalTo: topView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            myTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            myTableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
            myTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            myTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.myTableView.reloadData()
        
    }

    func LogData(data: TimeLog) {
            self.resultTimeLog.append(data)
    }
    
}
extension LogVC: UITableViewDelegate, UITableViewDataSource {
        
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return resultTimeLog.last?.roundCount ?? 0
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath as IndexPath) as! MyTableViewCell
        let filteredLog = resultTimeLog.filter({
            $0.roundCount == indexPath.row + 1
        })
        let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "HH:mm:ss"
        filteredLog.forEach({
 
            let hStack: UIStackView = {
                let stack = UIStackView()
                stack.axis = .horizontal
                stack.translatesAutoresizingMaskIntoConstraints = false
                stack.distribution = .fillEqually
                return stack
            }()
            
            hStack.addArrangedSubview(setLabel("\($0.setCount)"))
            hStack.addArrangedSubview(setLabel(String(format: "%02d:%02d", $0.workoutTime/60, $0.workoutTime%60)))
            hStack.addArrangedSubview(setLabel(String(format: "%02d:%02d", $0.restTime/60, $0.restTime%60)))
            hStack.addArrangedSubview(setLabel(dateFormatter.string(from: $0.dateTime)))

            cell.setListStack.addArrangedSubview(hStack)
        })
        

         return cell
     }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let myTableViewCell = cell as! MyTableViewCell
        myTableViewCell.setListStack.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
      func setLabel(_ content: String) -> UILabel {
           let label = UILabel()
           
           label.text = content
           label.font = UIFont(name: "Jost*", size: 20)

           return label
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight*0.2
    }
    
    
}
