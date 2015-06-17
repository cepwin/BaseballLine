//
//  DetailViewController.swift
//  BaseballLine
//
//  Created by Wendy Sarrett on 4/12/15.
//  Copyright (c) 2015 Wendy Sarrett. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    var detailItem:[String:AnyObject] = [String:AnyObject]()
    
    var teams:Array<String> = Array<String>()
    
    
    @IBOutlet weak var detail: UINavigationItem!


    override func viewDidLoad() {
        super.viewDidLoad()
        let first_name = detailItem["first_name"] as! String
        let last_name = detailItem["last_name"] as! String

        detail.title = "\(first_name) \(last_name)"
        if(self.teams.count == 0) {
            self.teams = Array(self.detailItem.keys) as Array<String>
            let firstInd = find(teams,"first_name")
            teams.removeAtIndex(firstInd!) //I know it's there
            let lastInd = find(teams,"last_name")
            teams.removeAtIndex(lastInd!) //I know it's there
            
            
        }

        //  tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    //    self.configureView()
    }
    
    
    
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        // return sectionInfo.numberOfObjects
        return self.teams.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("stat", forIndexPath: indexPath) as! UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        // let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
        // cell.textLabel!.text = object.valueForKey("timeStamp")!.description
             var stat = teams[indexPath.item] as String
        stat = stat.stringByReplacingOccurrencesOfString("_", withString: " ", options: NSStringCompareOptions.CaseInsensitiveSearch)
        stat = stat.uppercaseString
        var text1 = "\(stat): \(detailItem[teams[indexPath.item]]!)"
        cell.textLabel!.text = text1 as NSString as String
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

