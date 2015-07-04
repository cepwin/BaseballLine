//
//  ConfigViewController.swift
//  BaseballLine
//
//  Created by Wendy Sarrett on 4/18/15.
//  Copyright (c) 2015 Wendy Sarrett. All rights reserved.
//

import UIKit
import CoreData

class ConfigViewController: UIViewController,ConfigTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var configLable: UITextField!
    
    var configureOptions = ["Select Teams", "Select Data to View"]
   // var managedObjectContext: NSManagedObjectContext? = nil
    //var teams : [String] = []
   // var teamsIds : [String] = []
    var teamSm : [String] = []
    var teamIdsSM : [String] = []
    var settings : [Bool] = []
    
    var teamT : [(key : String, value : String)] = []

    var defaults : NSUserDefaults = NSUserDefaults()

    //implements the table cell delegate
    func returnController() -> ConfigViewController {
        return self
    }
    
    func setList(setting:Bool, row:Int) {
        var team = split(self.teamT[row].key) {$0 == ";"}
        if(setting) {
            NSLog("id \(team[1]) row \(row)")
            self.teamIdsSM.append(team[1])
            self.teamSm.append(team[0])

        }
        else {
            self.teamIdsSM = self.teamIdsSM.filter{!contains([team[1]], $0)}
            self.teamSm = self.teamSm.filter{!contains([team[0]], $0)}
    
        }
        let tabObj = self.tabBarController as! TabBarController
        tabObj.teamIdsSM = self.teamIdsSM
        tabObj.teamsSM = self.teamSm
    }

    
    func didTapCell(cell: ConfigTableViewCell, cellValue: Bool,sender: AnyObject) {
        let ip = sender.indexPath as NSIndexPath
        NSLog("row \(ip.row)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabObj = self.tabBarController as! TabBarController
      //  self.teamsIds = tabObj.teamIds
      //  self.teams = tabObj.teams
        self.teamSm = tabObj.teamsSM
        self.teamIdsSM = tabObj.teamIdsSM
        self.teamT = Array(tabObj.teamHandler).sorted({$0.0 < $1.0})
        self.settings = [Bool](count: self.teamT.count, repeatedValue:false)
        tableView.reloadData()
        
    }
    
    @IBAction func SaveConfig(sender: AnyObject) {
        let tabObj = self.tabBarController as! TabBarController
        if tabObj.teamIdsSM.count > 3 {
            let alert = UIAlertView()
            alert.title = "Favorites"
            alert.message = "Only 3 favorite teams can be selected"
            alert.addButtonWithTitle("OK")
            alert.show()

        } else {
         self.defaults = NSUserDefaults(suiteName: "group.com.cepwin.BaseballLine")!
        self.defaults.setObject(tabObj.teamIdsSM, forKey: "teamIdsSM")
        
        self.defaults.synchronize()
        
        
        self.defaults.setObject(tabObj.teamsSM, forKey: "teamsSM")
        
        self.defaults.synchronize()
            tabObj.tableview?.sortTeams()
            tabObj.tableview?.teamsTable.reloadData()
            //self.tableView.reloadData()
            let alert = UIAlertView()
            alert.title = "Save"
            alert.message = "Favorites Saved"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
        

     }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        // return sectionInfo.numberOfObjects
        return self.teamT.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("confCell", forIndexPath: indexPath) as!ConfigTableViewCell
        //let cell = tableView.cellForRowAtIndexPath(indexPath) as! ConfigTableViewCell
        cell.switchImp.on = false
        cell.delegate = self
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    func configureCell(cell: ConfigTableViewCell, atIndexPath indexPath: NSIndexPath) {
        //let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
        // cell.textLabel!.text = object.valueForKey("timeStamp")!.description
        let tabObj = self.tabBarController as! TabBarController
        var stat  = split(teamT[indexPath.item].key) {$0 == ";"}
        var id = tabObj.teamIds[indexPath.item] as String
        var rowStr = stat[0].stringByReplacingOccurrencesOfString("|", withString: " ", options: NSStringCompareOptions.CaseInsensitiveSearch).uppercaseString
        var temp = stat[1].stringByReplacingOccurrencesOfString(" ", withString: "-", options: NSStringCompareOptions.CaseInsensitiveSearch)
        temp = temp.lowercaseString

        cell.teamLabel?.text = rowStr  as String
        cell.teamId.text = temp as String
        cell.switchImp.tag = indexPath.row
        NSLog("Cell tag \(cell.switchImp.tag)")
        let itm = indexPath.item
        if(contains(tabObj.teamIdsSM,tabObj.teamIds[indexPath.item] )) {
            NSLog(tabObj.teamIds[indexPath.item])
            cell.switchImp.on = true
            self.settings[indexPath.item] = true
        } else {
            self.settings[indexPath.item] = false
        }
          cell.settings = self.settings
        
    }
    

    
}
