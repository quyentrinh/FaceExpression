//
//  ResultCell.swift
//  FaceExpression
//
//  Created by Quyen Trinh on 4/24/19.
//  Copyright © 2019 Quyen Trinh. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
