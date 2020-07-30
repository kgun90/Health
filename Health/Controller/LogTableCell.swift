//
//  LogTableCell.swift
//  Health
//
//  Created by Geon Kang on 2020/07/24.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit
import RealmSwift

class LogTableCell: UITableViewCell {

    @IBOutlet weak var logNumber: UILabel!
    @IBOutlet weak var workoutTime: UILabel!
    @IBOutlet weak var restTime: UILabel!
    @IBOutlet weak var logTime: UILabel!
}
