//
//  RecordCell.swift
//  Health
//
//  Created by Geon Kang on 2020/09/08.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {
    @IBOutlet weak var blockView: UIView!
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var recordTimeLabel: UILabel!
    @IBOutlet weak var totalWorkoutLabel: UILabel!
    @IBOutlet weak var totalRestLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        blockView.layer.cornerRadius = blockView.frame.size.height / 5
        blockView.backgroundColor = .white
        contentView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
