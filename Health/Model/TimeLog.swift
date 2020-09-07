//
//  TimeLog.swift
//  Health
//
//  Created by Geon Kang on 2020/07/23.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit
import RealmSwift


class TimeLog: Object {
    @objc dynamic var workoutTime: Int = 0
    @objc dynamic var restTime: Int = 0
    @objc dynamic var setCount: Int = 0
    @objc dynamic var roundCount: Int = 0
    @objc dynamic var dateTime: Date = Date()
}
