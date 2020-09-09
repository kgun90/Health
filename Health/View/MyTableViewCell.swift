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
    @IBOutlet weak var labelStack: UIStackView!
    
    @IBOutlet weak var marginView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    
        contentView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 250/255, alpha: 1.0)
        marginView.backgroundColor = .white
        marginView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
