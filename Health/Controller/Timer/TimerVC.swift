//
//  TimerViewController.swift
//  Health
//
//  Created by Geon Kang on 2020/07/22.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit
import RealmSwift

protocol TimerDataDelegate {
    func LogData(data: TimeLog)
}

class TimerVC: UIViewController {

    @IBOutlet weak var timerMain: UIButton!
    @IBOutlet weak var nextState: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var timerStatusLabel: UILabel!
    @IBOutlet weak var timerMainLabel: UILabel!
   
    @IBOutlet weak var timerTypeLabel: UILabel!
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var nextStateLabel: UILabel!
    @IBOutlet weak var nextTimeLabel: UILabel!
    
        
 
    
    enum timerStatus{
        case preWorkout
        case workoutStart
        case restStart
        case pause
        case stop
        case interval
        case result
        
        func getLabel() -> TimerAssets {
            switch self {
            case .preWorkout:
                return TimerAssets(color: UIColor(red: 255.0/255.0, green: 156.0/255.0, blue:  36.0/255.0, alpha: 1.0),
                                   type: "",
                                   status: "Timer Starts in",
                                   tab: "",
                                   font: UIFont(name: "Jost*", size: 120.0)!)
            case .workoutStart:
                return TimerAssets(color: UIColor(red: 119.0/255.0, green: 221.0/255.0, blue: 119.0/255.0, alpha: 1.0),
                                   type: "WORKOUT",
                                   status: "",
                                   tab: "Tap to Pause Timer",
                                   font: UIFont(name: "Jost*", size: 85.0)!)
            case .restStart:
                return TimerAssets(color: UIColor(red:   2.0/255.0, green: 125.0/255.0, blue: 255.0/255.0, alpha: 1.0),
                                   type: "REST",
                                   status: "",
                                   tab: "Tap to Pause Timer",
                                   font: UIFont(name: "Jost*", size: 85.0)!)
            case .pause:
                return TimerAssets(color: UIColor(red: 255.0/255.0, green: 221.0/255.0, blue:   0.0/255.0, alpha: 1.0),
                                   type: "",
                                   status: "PAUSE",
                                   tab: "Tap to Continue Timer \n Double Tap to Next Step",
                                   font: UIFont(name: "Jost*", size: 85.0)!)
            case .stop:
                return TimerAssets(color: UIColor(red: 110.0/255.0, green: 110.0/255.0, blue: 110.0/255.0, alpha: 1.0),
                                   type: "",
                                   status: "",
                                   tab: "Tap to Start Timer",
                                   font: UIFont(name: "Jost*", size: 85.0)!)
            case .interval:
                return TimerAssets(color: UIColor(red: 255.0/255.0, green: 105.0/255.0, blue:  97.0/255.0, alpha: 1.0),
                                   type: "INTERVAL",
                                   status: "Next Round Start in",
                                   tab: "Double Tap to Skip",
                                   font: UIFont(name: "Jost*", size: 120.0)!)
            case .result:
                return TimerAssets(color: UIColor(red: 135.0/255.0, green:  62.0/255.0, blue: 185.0/255.0, alpha: 1.0),
                                   type: "RESULT",
                                   status: "FINISH!",
                                   tab: "You made it!",
                                   font: UIFont(name: "Jost-Medium", size: 62.0)!)
            }
        }
        
        func timeSet() -> Int {
            switch self {
            case .preWorkout:
                return 2
            case .workoutStart:
                if UserDefaults.standard.bool(forKey: "switchState") {
                    return UserDefaults.standard.integer(forKey: "workoutTime") * 60
                } else {
                    return 0
                }
            case .restStart:
                return UserDefaults.standard.integer(forKey: "restTime") * 60
            case .interval:
                return UserDefaults.standard.integer(forKey: "intervalTime")
            default:
                return 0
            }
        }
        func nextLabel(_ sig: Int?, _ lastSet: Bool) -> String {
            switch self {
            case .workoutStart:
                return "REST"
            case .restStart:
                if lastSet {
                    return "INTERVAL"
                } else {
                     return "WORKOUT"
                }
            case .pause:
                if let _ = sig {
                    if lastSet {
                        return "INTERVAL"
                    } else {
                        return "WORKOUT"
                    }
                } else {
                    return "REST"
                    
                }
            case .result:
                return "WORKOUT TIME"
            default:    // stop, preWorkout, interval
                return "WORKOUT"
            }

        }
        func nextTime(_ sig: Int?) -> Int {
            switch self {
            case .preWorkout, .restStart, .stop, .interval:
                if UserDefaults.standard.bool(forKey: "switchState") {
                    return UserDefaults.standard.integer(forKey: "workoutTime") * 60
                } else {
                    return 0
                }
            case .workoutStart:
                return UserDefaults.standard.integer(forKey: "restTime") * 60
            case .pause:
                if let _ = sig {
                    if UserDefaults.standard.bool(forKey: "switchState") {
                     return UserDefaults.standard.integer(forKey: "workoutTime") * 60
                 } else {
                     return 0
                 }
               } else {
                   return UserDefaults.standard.integer(forKey: "restTime") * 60
               }
            default:
                return 0
                    
            }
        }
    }

    var countType = UserDefaults.standard.bool(forKey: "switchState")
    var totalSet     = UserDefaults.standard.integer(forKey: "setCount")
    var totalRound   = UserDefaults.standard.integer(forKey: "roundCount")
    var currentSet   = 1
    var currentRound = 1
    
    var workoutTime: Int?
    var restTime: Int?
    
    var delegate: TimerDataDelegate?
    var setArray = [TimeLog]()
    var mTimer: Timer?
    var setUp: Int {
        get {
            return currentSet
        }
        set(newValue) {
            if newValue < totalSet{
                currentSet = newValue + 1
            }
        }
    }
    var roundUp: Int {
        get {
            return currentRound
        }
        set(newVal) {
            if newVal < totalRound{
                currentRound = newVal + 1
            }
        }
    }
  

    var status = timerStatus.stop
   
    var workoutSeq = Date()
    
    let realm = try! Realm()
    let now = Date()
    
    var timerCount = 0
    
    var doubleTapSignal = false

    var pauseState = timerStatus.workoutStart

    override func viewDidLoad() {
        super.viewDidLoad()
        timerMain.layer.cornerRadius = 8
        nextState.layer.cornerRadius = 8
        
        timerStateChange()
        
            
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTapGesture.numberOfTouchesRequired = 1
        timerMain.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        timerMain.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }

    @objc func handleSingleTap() {
        if status != timerStatus.preWorkout && status != timerStatus.interval {
            timerTapAction(status)
        }
    
    }
    @objc func handleDoubleTap() {
        if status == timerStatus.pause || status == timerStatus.interval{
            doubleTapSignal = true
            timerTapAction(status)
        }
        
       
        
    }
    
//MARK: - Timer handling
    func timerOn() {
       
          if let timer = mTimer {
              if !timer.isValid {
                  mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
              }
          } else {
              mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
          }
      }
      func timerOff() {
          if mTimer != nil {
              mTimer?.invalidate()
              mTimer = nil
          }
      }
    
    @objc func timerCallback() {
     
        if status != timerStatus.stop && status != timerStatus.pause {
            if countType == false && status == timerStatus.workoutStart{
                  timerCount += 1
            } else {
                timerCount -= 1
            }
          
            timerLabel.text = timeDisplay(timerCount)
        } // timer 상태가 workoutStart, restStart, interval 일때 카운트 함
        if timerCount == 0 {
            timerOff()
            timerTimeoutAction(status)
        } // timeout 상태 (0이 될 때), 맞는 동작

    }
    func timerFormat(_ time: Int) -> String {
        return String(format: "%02d:%02d", time/60, time%60)

    }
    func timeDisplay(_ number: Int) -> String {
       
        if status == timerStatus.interval || status == timerStatus.preWorkout{
            return "\(number)"
        } else if status == timerStatus.result {
            return "\(totalSet)SETS\n\(totalRound)ROUNDS"
        } else {
            return timerFormat(number)
        }

    }
    func setRoundDisplay() {
        if status != timerStatus.stop {
           self.setLabel.text = "\(currentSet)/\(totalSet) SET"
           self.roundLabel.text = "\(currentRound)/\(totalRound) ROUND"
        } // timer가 동작할 때 set/round 수를 표시한다
    }
    
    //MARK: - TimerTapAction
    func timerTapAction(_ tapStatus: timerStatus) {
        timerOff()
    
        
        switch tapStatus {
        case .preWorkout:
            status = timerStatus.workoutStart
            initTimer()
        case .workoutStart:
            status = timerStatus.pause
            // timer 동작 중 Tap 동작시 Pause 상태로 변경하며 이때 타이머도 일시정지
        case .restStart:
       
            restTime = timerStatus.restStart.timeSet() - timerCount
            status = timerStatus.pause
            
        case .pause:
            if doubleTapSignal {
                if let _ = workoutTime{ // rest -> pause 상태
                    status = timerStatus.workoutStart
                    recordLog()
                    workoutTime = nil
                    initTimer()
                } else { // workout -> pause 상태
                    if countType {
                        workoutTime = timerStatus.workoutStart.timeSet() - timerCount
                    } else {
                        workoutTime = timerCount
                    }
                    status = timerStatus.restStart
                    initTimer()
                }
            
            } else {
                if let _ = workoutTime {
                    status = timerStatus.restStart
                } else {
                    status = timerStatus.workoutStart
                }
            }
           // pause 동작 중 Tap 동작시 Start 상태로 변경하며 타이머도 재동작
        case .stop:
            workoutSeq = Date()
            status = timerStatus.preWorkout
            initTimer()
            // stop 상태에서 Tap 동작시 Start 상태로 변경하며 타이머 초기화 및 동작 진행
        case .interval:
            if doubleTapSignal {
                status = timerStatus.workoutStart
                initTimer()
            }
            // interval 상태에서 Tap 동작시 stop 상태로 변경하며 타이머 초기화 및 정지 진행
        case .result:
            break
    }
        doubleTapSignal = false
        timerStateChange()
        
        
    }
    
    func timerTimeoutAction(_ statusGet: timerStatus) {
        timerOff()

        switch statusGet {
        case .preWorkout:
            status = timerStatus.workoutStart
          case .workoutStart:
            status = timerStatus.restStart
            workoutTime = status.timeSet()
         case .restStart:
            if currentSet < totalSet {
                status = timerStatus.workoutStart
                recordLog()
            } else {
                status = timerStatus.interval
            }
            restTime = status.timeSet()
  
        case .pause, .stop:
            break
        case .interval:
            status = timerStatus.workoutStart

        case .result:
            createDB(setArray)
        }
        timerStateChange()
        initTimer()
    }

    func countSetRound() {
        if currentSet < totalSet {
            setUp = currentSet
        } else {
            currentSet = 1
            if currentRound < totalRound {
                roundUp = currentRound
                status = timerStatus.interval
                timerStateChange()
                initTimer()
            } else {
                status = timerStatus.result
                timerTimeoutAction(status)
            }
        }
     }

    
    func initTimer() {
        if status != timerStatus.pause {
              timerCount = status.timeSet()
        }
        timerLabel.text = timeDisplay(timerCount)
    }
  
    
    func timerStateChange() {
        var lastSet = false
        let totalTime = setArray.reduce(0) {
            $0 + $1.workoutTime + $1.restTime
        }
        switch status {
        case .preWorkout, .workoutStart, .restStart, .interval:
            timerOn()
        default: break
            
        }
        self.timerStatusLabel.text = status.getLabel().statusLabel
        self.timerMainLabel.text = status.getLabel().mainTabLabel
        self.timerTypeLabel.text = status.getLabel().typeLabel
        self.timerLabel.font = status.getLabel().timerFont
        self.timerMain.backgroundColor = status.getLabel().bgColor
            
        if currentSet == totalSet {
            lastSet = true
        } else {
            lastSet = false
        }
          
        if status == timerStatus.result {
            self.timerLabel.textAlignment = .left
            self.nextLabel.text = "TOTAL"
            self.nextTimeLabel.text = timerFormat(totalTime)
            self.nextStateLabel.text = status.nextLabel(workoutTime, lastSet)
        } else {
            self.nextLabel.text = "NEXT"
            self.nextStateLabel.text = status.nextLabel(workoutTime, lastSet)
            self.nextTimeLabel.text = timerFormat(status.nextTime(workoutTime))
        }
        
    
        setRoundDisplay()
        
       
    }
    
 
    
//MARK: - Log write
    
    func recordLog(){
        let timeLog = TimeLog()
       
        timeLog.workoutTime = workoutTime ?? 0
        timeLog.restTime = restTime ?? 0
        timeLog.dateTime = Date()
        timeLog.setCount = currentSet
        timeLog.roundCount = currentRound
        timeLog.workoutSeq = workoutSeq

        countSetRound()
        delegate?.LogData(data: timeLog)
        setArray.append(timeLog)
       
   
    }
    
    
//MARK: - Realm DB
  
    func createDB(_ timeLog: [TimeLog]){
        setArray = []
        do {
            try realm.write{
                realm.add(timeLog)
           }
        } catch {
           print("ERRPORRRRRRR")
        }
    }
    @IBAction func deleteDB(_ sender: Any) {
        try! realm.write({
            realm.deleteAll()
        })
    }

   deinit {
         print("TimerVC Deinit")
     }
}
