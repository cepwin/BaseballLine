//
//  ConfigChoiceViewController.swift
//  BaseballLine
//
//  Created by Wendy Sarrett on 7/5/15.
//  Copyright (c) 2015 Wendy Sarrett. All rights reserved.
//

import UIKit

class ConfigChoiceViewController: UITableViewController, ConfigViewControllerDelegate {
    @IBOutlet weak var sortChoice: UISegmentedControl!
    var configVewController : ConfigViewController = ConfigViewController()
    
    @IBAction func Save(sender: AnyObject) {
        self.configVewController.delegate = self
        self.configVewController.SaveConfig(sender)
        let defaults = NSUserDefaults(suiteName: "group.com.cepwin.BaseballLine")!
        let tabObj = self.tabBarController as! TabBarController

        defaults.setObject(tabObj.sortOrder, forKey: "sortOrder")
        
        defaults.synchronize()

    }
    
    @IBAction func selectSort(sender: AnyObject) {
        let tabObj = self.tabBarController as! TabBarController
        tabObj.sortOrder = sortChoice.selectedSegmentIndex
    }

    
    func returnTabBarController()->TabBarController {
        return self.tabBarController as! TabBarController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabObj = self.tabBarController as! TabBarController
        sortChoice.selectedSegmentIndex = tabObj.sortOrder
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController
        if(vc.title == "Configuration") {
            let conf = vc as! ConfigViewController
            conf.delegate = self
            self.configVewController = conf
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }


}
