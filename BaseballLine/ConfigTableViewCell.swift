//
//  ConfigTableViewCell.swift
//  BaseballLine
//
//  Created by Wendy Sarrett on 5/19/15.
//  Copyright (c) 2015 Wendy Sarrett. All rights reserved.
//

import UIKit

protocol ConfigTableViewCellDelegate {
    func returnController()->ConfigViewController
    func setList(setting:Bool, row:Int)
}

class ConfigTableViewCell: UITableViewCell {
    @IBOutlet weak var teamLabel: UITextField!

    @IBOutlet weak var switchImp: UISwitch!
    
    
    @IBOutlet weak var teamId: UILabel!
    
    var delegate : ConfigViewController? = nil
    var settings:[Bool] = []
    var setting:Bool = false
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // var controller = self.superview?.superview as ConfigViewController
      //  controller.tabViewController
    }
    
    

   @IBAction func changeSwitch(sender: AnyObject) {
         NSLog("tag selected \(sender.tag)")
        if(switchImp.on == true) {
            self.setting = true
        } else {
            self.setting = false
      }
    self.delegate?.setList(switchImp.on, row:sender.tag)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if(switchImp.on) {
            
        } else {
            
        }
    }
    
    

}
