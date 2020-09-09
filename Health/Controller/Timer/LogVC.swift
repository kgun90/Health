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
        return tv
    }()
 
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let countSet: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let countRound: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let screenHeight = UIScreen.main.bounds.height
    let textColor = UIColor(red: 69/255, green: 79/255, blue: 99/255, alpha: 1.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        let safeArea = self.view.layoutMarginsGuide
        let title: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 250/255, alpha: 1.0)
 
        myTableView.layer.cornerRadius = 10
        myTableView.layer.masksToBounds = true
        myTableView.separatorStyle = .none
        myTableView.allowsSelection = false
        myTableView.backgroundColor = .clear
        
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyTableViewCell")
       
       
        self.view.addSubview(myTableView)
        self.view.addSubview(topView)
        self.topView.addSubview(title)
        self.view.addSubview(countSet)
        self.view.addSubview(countRound)

        title.textColor = textColor
        title.font = UIFont(name: "Jost*", size: 40.0)
        title.text = "Log"
        title.backgroundColor = .clear

        countSet.textColor = textColor
        countSet.font = UIFont(name: "Jost*", size: 20.0)
       
        countSet.backgroundColor = .clear
     

        countRound.textColor = textColor
        countRound.font = UIFont(name: "Jost*", size: 20.0)
        
        countRound.backgroundColor = .clear
        
        
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topView.topAnchor.constraint(equalTo: self.view.topAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: screenHeight * 0.19)
        ])
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 24),
            title.topAnchor.constraint(equalTo: topView.topAnchor, constant: 84),
            title.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -286),
            title.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -14)
        ])

        NSLayoutConstraint.activate([
            myTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            myTableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 83),
            myTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            myTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            countRound.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 217),
            countRound.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24)
        ])
        NSLayoutConstraint.activate([
            countSet.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 217),
            countSet.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -26)
        ])
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    func LogData(data: TimeLog) {
        self.resultTimeLog.append(data)
        countLabelDisplay(resultTimeLog.last?.setCount ?? 0, resultTimeLog.last?.roundCount ?? 0)
        self.myTableView.reloadData()
    }
    func countLabelDisplay(_ setCount: Int, _ roundCount: Int) {
        countSet.text = "\(setCount) SET"
        countRound.text = "\(roundCount) ROUND"
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
            
            hStack.addArrangedSubview(setLabel("SET \($0.setCount)"))
            hStack.addArrangedSubview(setLabel(String(format: "%02dm%02ds", $0.workoutTime/60, $0.workoutTime%60)))
            hStack.addArrangedSubview(setLabel(String(format: "%02dm%02ds", $0.restTime/60, $0.restTime%60)))
            hStack.addArrangedSubview(setLabel(dateFormatter.string(from: $0.dateTime)))

            cell.setListStack.addArrangedSubview(hStack)
            
            switch $0.roundCount {
                case 1:
                    cell.roundLabel.text = "\($0.roundCount)ST"
                case 2:
                    cell.roundLabel.text = "\($0.roundCount)ND"
                case 3:
                    cell.roundLabel.text = "\($0.roundCount)RD"
                default:
                    cell.roundLabel.text = "\($0.roundCount)TH"
            }
            
        })
        
        cell.layer.cornerRadius = 10
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
        label.textAlignment = .center
        label.font = UIFont(name: "Jost*", size: 16)


        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight*0.21
    }
    
    
}
