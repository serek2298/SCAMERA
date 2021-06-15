//
//  alertCell.swift
//  Flash Chat iOS13
//
//  Created by iSero on 14/06/2021.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

class alertCell: UITableViewCell {

    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var plateLabel: UILabel!
    @IBOutlet weak var photo: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
