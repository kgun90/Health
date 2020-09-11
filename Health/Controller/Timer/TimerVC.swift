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
    @IBOutlet weak var timerSubLabel: UILabel!
   
    @IBOutlet weak var timerTypeLabel: UILabel!
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    @IBOutlet weak var nextStateLabel: UILabel!
    @IBOutlet weak var nextTimeLabel: UILabel!
    
        
    
    enum timerStatus {
        case preWorkout
        case workoutStart
        case restStart
        case pause
        case stop
        case interval
    }
    enum timerTypeState {
        case countDown
        case countUp
        case roundInterval
        case rest
    }
    struct colors {
        let preWorkoutBackground = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue:  36.0/255.0, alpha: 1.0)
        let workoutBackground    = UIColor(red: 119.0/255.0, green: 221.0/255.0, blue: 119.0/255.0, alpha: 1.0)
        let restBackground       = UIColor(red:   2.0/255.0, green: 125.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        let pauseBackground      = UIColor(red: 255.0/255.0, green: 221.0/255.0, blue:   0.0/255.0, alpha: 1.0)
        let stopBackground       = UIColor(red: 110.0/255.0, green: 110.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        let intervalBackground   = UIColor(red: 255.0/255.0, green: 105.0/255.0, blue:  97.0/255.0, alpha: 1.0)
        // UIColor 색상을 RG직접 부여할 때는 이와같이 사용한다.
    }
    
    struct timeSet {
        var preWorkout = 2
        var workout    = 2
        var rest       = 2
        var interval   = 2
        var stop       = 0
        var pause      = 0
    }
    struct logData {
        var workoutTime = 0
        var restTime = 0
        var logDate = Date()
        var setNum = 0
        var roundNum = 0
    }

    var totalSet     = 5
    var currentSet   = 1
    var totalRound   = 5
    var currentRound = 1
    var workoutTime = 0
    var restTime = 0
    
    var delegate: TimerDataDelegate?
    
    var setArray = [TimeLog]()
    
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
    
    struct labelSet {
        let workout  = "WORKOUT"
        let rest     = "REST"
        let interval = "INTERVAL"
        let pause    = "PAUSED"
        let blank    = ""
    }


    
    var status = timerStatus.stop
    var type = timerTypeState.countDown
    var timerType = timerTypeState.countDown
    var nextStatus = timerStatus.stop
    var timerSet = TimerAssets()
    var workoutSeq = Date()
    
    let realm = try! Realm()

    var mTimer: Timer?
    let now = Date()
    
    var timerCount = 0
    
    var doubleTapSignal = false

    var pauseState = timerStatus.workoutStart

    override func viewDidLoad() {
        super.viewDidLoad()
        timerMain.layer.cornerRadius = 8
        nextState.layer.cornerRadius = 8
        
        timerStateChange(status)
        nextStateChage(status)
        
            
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

    @objc func timerCallback() {
        if status != timerStatus.stop && status != timerStatus.pause {
            timerCount -= 1
            timerLabel.text = timeDisplay(timerCount)
        } // timer 상태가 workoutStart, restStart, interval 일때 카운트 함
        if timerCount == 0 {// && type == timerTypeState.countDown {
            timerOff()
            
            timerTimeoutAction(status)
        } // timeout 상태 (0이 될 때), 맞는 동작


    }
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
    func timeDisplay(_ number: Int) -> String {
       
        if status == timerStatus.interval || status == timerStatus.preWorkout{
            return "\(number)"
        } else {
            return String(format: "%02d:%02d", number/60, number%60)
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
        let setTime = timeSet()
        timerOff()
        
        switch tapStatus {
        case .preWorkout:
            status = timerStatus.workoutStart
            initTimer(status)
            timerStateChange(status)
        case .workoutStart:
            status = timerStatus.pause
            pauseState = timerStatus.workoutStart
            workoutTime = setTime.workout - timerCount
            timerStateChange(status)
            // timer 동작 중 Tap 동작시 Pause 상태로 변경하며 이때 타이머도 일시정지함
        case .restStart:
            status = timerStatus.pause
            pauseState = timerStatus.restStart
            restTime = setTime.rest - timerCount
            timerStateChange(status)
            recordLog()
        case .pause:
            if pauseState == timerStatus.workoutStart {
                if doubleTapSignal {
                    status = timerStatus.restStart
                    initTimer(status)
                } else {
                    status = timerStatus.workoutStart
                }
                
            } else if pauseState == timerStatus.restStart {
                if doubleTapSignal {
                    
                    if currentSet < totalSet {
                        status = timerStatus.workoutStart
                    } else {
                        status = timerStatus.interval
                    }
                    initTimer(status)
                    countSetRound()
                } else {
                    status = timerStatus.restStart
                }
            }
            
            timerStateChange(status)
           // pause 동작 중 Tap 동작시 Start 상태로 변경하며 타이머도 재동작
        case .stop:
            workoutSeq = Date()
         
            status = timerStatus.preWorkout
            initTimer(status)
            timerStateChange(status)
            // stop 상태에서 Tap 동작시 Start 상태로 변경하며 타이머 초기화 및 동작 진행
        case .interval:
            if doubleTapSignal {
                status = timerStatus.workoutStart
                initTimer(status)
                timerStateChange(status)
            }
            
            
           
            // interval 상태에서 Tap 동작시 stop 상태로 변경하며 타이머 초기화 및 정지 진행
        }
        doubleTapSignal = false
    }
    
    func timerTimeoutAction(_ statusGet: timerStatus) {
        let setTime = timeSet()
        timerOff()

        switch statusGet {
        case .preWorkout:
            status = timerStatus.workoutStart
            initTimer(status)
            timerStateChange(status)
            
        case .workoutStart:
            status = timerStatus.restStart
            workoutTime = setTime.workout
            initTimer(status)
            timerStateChange(status)
            
        case .restStart:
            if currentSet < totalSet {
                status = timerStatus.workoutStart
            } else {
                status = timerStatus.interval
            }
            restTime = setTime.rest
            recordLog()
     
            countSetRound()
            initTimer(status)
            timerStateChange(status)
            
        case .pause:
            timerStateChange(status)
            
        case .stop:
            initTimer(status)
            timerStateChange(status)
            createDB(setArray)
            
        case .interval:
            status = timerStatus.workoutStart
            initTimer(status)
            timerStateChange(status)
        }
        
    }


    func countSetRound() {
    
        if currentSet < totalSet {
            setUp = currentSet
           
        } else {
            currentSet = 1
            if currentRound < totalRound {
                roundUp = currentRound
                status = timerStatus.interval
                timerStateChange(status)
                initTimer(status)
            } else {
                status = timerStatus.stop
                timerTimeoutAction(status)
            }
            
        }
   
        
    }

    
    func initTimer(_ status: timerStatus) {
        let timeOf = timeSet()
        switch status {
        case .preWorkout:
            timerCount = timeOf.preWorkout
        case .workoutStart:
            timerCount = timeOf.workout
        case .restStart:
            timerCount = timeOf.rest
        case .pause:
            timerCount = timeOf.pause
        case .stop:
            timerCount = timeOf.stop
        case .interval:
            timerCount = timeOf.interval
        }

     timerLabel.text = timeDisplay(timerCount)
       
        
    }
  
    
    func timerStateChange(_ status: timerStatus) {
        var statusLabel = ""
        var mainTaplLabel = ""
        var subTapLabel = ""
        var timerType = ""
        var bgColor = UIColor()
        var timeFont = UIFont()
        
        let color = colors()
        let timerLabelSet = labelSet()
   
        
        switch status {
        case .preWorkout:
            statusLabel = "Timer Starts in"
            mainTaplLabel = timerLabelSet.blank
            subTapLabel = timerLabelSet.blank
            bgColor = color.preWorkoutBackground

            timerOn()
            
            timerType = timerLabelSet.blank
            timeFont = UIFont(name: "Jost*", size: 120.0)!
        case .workoutStart:
            statusLabel = timerLabelSet.blank
            mainTaplLabel = "Tap to Pause Timer"
            subTapLabel = timerLabelSet.blank
            bgColor = color.workoutBackground
            
            print("workout")
            timerOn()
            timerType = timerLabelSet.workout
            timeFont = UIFont(name: "Jost*", size: 85.0)!
            
        case .restStart:
            statusLabel = timerLabelSet.blank
            mainTaplLabel = "Tap to Pause Timer"
            subTapLabel = timerLabelSet.blank
            bgColor = color.restBackground
            // UIColor 색상을 직접 부여할 때는 이와같이 사용한다.
            print("rest")
            timerOn()
            timerType = timerLabelSet.rest
            timeFont = UIFont(name: "Jost*", size: 85.0)!
            
        case .pause:
            statusLabel = timerLabelSet.pause
            mainTaplLabel = "Tap to Continue Timer"
            subTapLabel = "Double Tap to Next Step"
            bgColor = color.pauseBackground
            if pauseState == timerStatus.workoutStart {
                timerType = timerLabelSet.workout
            } else if pauseState == timerStatus.restStart {
                timerType = timerLabelSet.rest
            } else {
                timerType = timerLabelSet.blank
            }
            
            timeFont = UIFont(name: "Jost*", size: 85.0)!
            
        case .stop:
            statusLabel = timerLabelSet.blank
            mainTaplLabel = "Tap to Start Timer"
            subTapLabel = timerLabelSet.blank
            bgColor = color.stopBackground
      
            timerType = timerLabelSet.blank
            timeFont = UIFont(name: "Jost*", size: 85.0)!
            
        case .interval:
            statusLabel = "Next Round Start in"
            mainTaplLabel = "Double Tap to Skip"
            subTapLabel = timerLabelSet.blank
            bgColor = color.intervalBackground
     
            timerOn()
            timerType = timerLabelSet.interval
            timeFont = UIFont(name: "Jost*", size: 120.0)!
            
        }
        
        self.timerStatusLabel.text = statusLabel
        self.timerMainLabel.text = mainTaplLabel
        self.timerSubLabel.text = subTapLabel
        self.timerTypeLabel.text = timerType
        self.timerLabel.font = timeFont
        self.timerMain.backgroundColor = bgColor
        nextStateChage(status)
        setRoundDisplay()
    }
    
    func nextStateChage(_ nextStatus: timerStatus) {
        var statusLabel = ""
        var timerLabel = 0
        let timerLabelOf = labelSet()
        let timeOf = timeSet()
        
        switch nextStatus {
        case .preWorkout:
            statusLabel = timerLabelOf.workout
            timerLabel = timeOf.workout
        case .workoutStart:
            statusLabel = timerLabelOf.rest
            timerLabel = timeOf.rest
        case .restStart:
            if currentSet < totalSet {
                statusLabel = timerLabelOf.workout
                timerLabel = timeOf.workout
  
            } else {
                statusLabel = timerLabelOf.interval
                timerLabel = timeOf.interval
            }

        case .pause:
            if pauseState == timerStatus.workoutStart {
                statusLabel = timerLabelOf.rest
                timerLabel = timeOf.rest
            } else if pauseState == timerStatus.restStart {
                statusLabel = timerLabelOf.interval
                timerLabel = timeOf.interval
            } else {
                statusLabel = timerLabelOf.workout
                timerLabel = timeOf.workout
            }
        case .interval:
            statusLabel = timerLabelOf.workout
            timerLabel = timeOf.workout
        case .stop:
            statusLabel = timerLabelOf.workout
            timerLabel = timeOf.workout
        }
        
        self.nextStateLabel.text = statusLabel
        self.nextTimeLabel.text = String(format: "%02d:%02d", timerLabel/60, timerLabel%60)
    }
    
//MARK: - Log write
    
    func recordLog(){
        let timeLog = TimeLog()
       
        timeLog.workoutTime = workoutTime
        timeLog.restTime = restTime
        timeLog.dateTime = Date()
        timeLog.setCount = currentSet
        timeLog.roundCount = currentRound
        timeLog.workoutSeq = workoutSeq

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

   
}
