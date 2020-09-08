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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        blockView.layer.cornerRadius = blockView.frame.size.height / 5
        blockView.backgroundColor = .red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
