//
//  setDataCell.swift
//  Health
//
//  Created by Geon Kang on 2020/09/05.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit

class setDataCell: UITableViewCell {
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
