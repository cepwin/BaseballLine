//
//  MainTableViewCell.swift
//  BaseballLine
//
//  Created by Wendy Sarrett on 7/18/15.
//  Copyright (c) 2015 Wendy Sarrett. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var record: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
