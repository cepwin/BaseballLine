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
    //let tableView:UITableView = sender.superview as! UITableView
        NSLog("tag selected \(sender.tag)")
       // let tableView = self.superview?
        //let ip = tableView?.indexPathForCell(self)
        //let ip = self.superview?.superview.indexPathForCell(self)
       // let ip:NSIndexPath = NSIndexPath(index: sender.tag)
       // let row:Int = ip!.row
        //let tableView = self.superview?.superview
        //let labelId = self.teamId as UILabel
        //let idStr:String = labelId.text!
       // let controller = self.delegate?.returnController()
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
