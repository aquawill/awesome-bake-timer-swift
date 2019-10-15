//
//  ItemTableViewCell.swift
//  baker-timer
//
//  Created by Wu, Guan-Ling on 15/03/2017.
//  Copyright © 2017 Wu, Guan-Ling. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var index: UILabel!
    @IBOutlet weak var upperTempValue: UILabel!
    @IBOutlet weak var bottomTempValue: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
