//
//  TimerAssets.swift
//  Health
//
//  Created by Geon Kang on 2020/08/20.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit

struct TimerAssets {
    let bgColor: UIColor
    let typeLabel: String
    let statusLabel: String
    let mainTabLabel: String
    let timerFont: UIFont
    
    init (color: UIColor, type: String, status: String, tab: String, font: UIFont) {
        self.bgColor = color
        self.typeLabel = type
        self.statusLabel = status
        self.mainTabLabel = tab
        self.timerFont = font
    }
      
}
