//
//  MyTableViewCell.swift
//  Health
//
//  Created by Geon Kang on 2020/08/30.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit


class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var setListStack: UIStackView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

