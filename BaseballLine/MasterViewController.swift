//
//  MasterViewController.swift
//  BaseballLine
//
//  Created by Wendy Sarrett on 6/14/15.
//  Copyright (c) 2015 Wendy Sarrett. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var objects = [AnyObject]()

    
    // var teamData:MLBTeamObject = MLBTeamObject()
    var teamDictSM:[String:[String:AnyObject]] = [String:[String:AnyObject]]()
    
    var teamDict2:[String:[String:AnyObject]] = [String:[String:AnyObject]]()
    
    //var teamDictionary = [String : MLBTeamObject]()
    
    var teamIds:[String] = [String]()
    var teams:[String] = [String]()
    
    var teamIdsSM:[String] = [String]()
    var teamsSM:[String] = [String]()
    
    
    
    
    @IBOutlet var teamsTable: UITableView!
    

    
    
    var parsedObject  : NSDictionary = NSDictionary()
    var defaults : NSUserDefaults = NSUserDefaults()
    var loadTeams = true
    
    
    @IBOutlet weak var updateData: UINavigationItem!
    
    @IBAction func update(sender: AnyObject) {
        getData()
        let alert = UIAlertView()
        alert.title = "New Data"
        alert.message = "Data Loaded"
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func getData() {
        let tabObj = self.tabBarController as! TabBarController
        
        let alert = UIAlertView()
        alert.title = "No Network Connectivity"
        alert.message = "Can not download data"
        alert.addButtonWithTitle("OK")
        
        let url = NSURL(string: "https://erikberg.com/mlb/standings.json")
        let request = NSMutableURLRequest(URL: url!)
        let bundle = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        var userAgent = "BaseballLine/\(bundle)(cepwin@gmail.com)"
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        if tabObj.teams.count > 0 {
            loadTeams = false
        }
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            let httpResponse = response as! NSHTTPURLResponse
            if(httpResponse.statusCode == 429) {
                let dictionary:NSDictionary = httpResponse.allHeaderFields
                let times = dictionary.valueForKey("xmlstats-api-remaining")!.integerValue as NSInteger
                if(times == 0) {
                    alert.title = "Wait for connection"
                    let date = NSDate().timeIntervalSince1970 as NSTimeInterval
                    let xmlReset:NSString? = dictionary.valueForKey("xmlstats-api-reset") as? NSString
                    if(xmlReset != nil) {
                        let  distance = date.distanceTo((xmlReset)!.doubleValue) as Double
                        alert.message = "waiting \(distance) seconds to retry"
                        
                    }
                }
            }
            if(error == nil) {
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
                var error:NSError? = nil
                
                self.parsedObject = NSJSONSerialization.JSONObjectWithData(data, options:   NSJSONReadingOptions.AllowFragments, error:&error) as! NSDictionary
                if(error == nil) {
                    let res1 = self.parsedObject.mutableArrayValueForKey("standing")
                    self.loadDataIntoObjs(res1)
                    self.sortTeams()
                    self.teamsTable.reloadData()
                }
            }
            else {
                alert.show()
                
            }
        }
        println("got data")
    }
    
    
    func loadDataIntoObjs(res1:NSMutableArray) {
        let tabObj = self.tabBarController as! TabBarController
        for i in 0...(res1.count-1) {
            // var teamData1 = MLBTeamObject()
            let resfst:NSDictionary = res1[i] as! NSDictionary
            var indu:[String:AnyObject] = [String:AnyObject]()
            var first_name = resfst.valueForKey("first_name") as! String
            var last_name = resfst.valueForKey("last_name") as! String
            
            indu.updateValue(resfst.valueForKey("conference")! , forKey: "conference")
            indu.updateValue(resfst.valueForKey("division")! , forKey: "division")
            indu.updateValue(resfst.valueForKey("rank")!, forKey: "rank")
            indu.updateValue(resfst.valueForKey("games_played")! , forKey: "games_played")
            let won = resfst.valueForKey("won")! as! Int
            let loss = resfst.valueForKey("lost")! as! Int
            var wonloss = "\(won) - \(loss)"
            indu.updateValue(wonloss , forKey: "won-lost")
            
            indu.updateValue(resfst.valueForKey("streak")! , forKey: "streak")
            indu.updateValue(resfst.valueForKey("win_percentage")! , forKey: "win_percentage")
            
            indu.updateValue(resfst.valueForKey("ordinal_rank")! , forKey: "ordinal_rank")
            indu.updateValue(resfst.valueForKey("first_name")! , forKey: "first_name")
            indu.updateValue(resfst.valueForKey("last_name")! , forKey: "last_name")
            indu.updateValue(resfst.valueForKey("games_back")! , forKey: "games_back")
            var pointsFor = resfst.valueForKey("points_for")! as! Int
            var pointsAg = resfst.valueForKey("points_against")! as! Int
            indu.updateValue("\(pointsFor) - \(pointsAg)" , forKey: "points_for-against")
            var homeWon = resfst.valueForKey("home_won")! as! Int
            var homeLost = resfst.valueForKey("home_lost")! as! Int
            var awayWon = resfst.valueForKey("away_won")! as! Int
            var awayLost = resfst.valueForKey("away_lost")! as! Int
            indu.updateValue("\(homeWon) - \(homeLost)", forKey: "home_won-lost")
            indu.updateValue("\(awayWon) - \(awayLost)", forKey: "away_won-lost")
            var conferenceWon = resfst.valueForKey("conference_won")! as! Int
            var conferenceLost = resfst.valueForKey("conference_won")! as! Int
            indu.updateValue("\(conferenceWon) - \(conferenceLost)", forKey: "conference_won-lost")
            indu.updateValue(resfst.valueForKey("last_five")! , forKey: "last_five")
            indu.updateValue(resfst.valueForKey("last_ten")! , forKey: "last_ten")
            
            indu.updateValue(resfst.valueForKey("points_allowed_per_game")! , forKey: "points_allowed_per_game")
            indu.updateValue(resfst.valueForKey("points_scored_per_game")! , forKey: "points_scored_per_game")
            indu.updateValue(resfst.valueForKey("point_differential")! , forKey: "point_differential")
            indu.updateValue(resfst.valueForKey("point_differential_per_game")! , forKey: "point_differential_per_game")
            indu.updateValue(resfst.valueForKey("points_scored_per_game")! , forKey: "points_scored_per_game")
            if(contains(tabObj.teamIdsSM,resfst.valueForKey("team_id") as! String)) {
                var induSM:[String:AnyObject] = [String:AnyObject]()
                induSM.updateValue(wonloss, forKey: "won-loss")
                induSM.updateValue(resfst.valueForKey("streak")! , forKey: "streak")
                induSM.updateValue(resfst.valueForKey("win_percentage")! , forKey: "win_%")
                induSM.updateValue(resfst.valueForKey("last_five")! , forKey: "last_5")
                induSM.updateValue(resfst.valueForKey("first_name")! , forKey: "first_name")
                induSM.updateValue(resfst.valueForKey("last_name")! , forKey: "last_name")

                self.teamDictSM.updateValue(induSM as Dictionary, forKey: resfst.valueForKey("team_id") as! String)
                
            }
            self.teamDict2.updateValue(indu as Dictionary, forKey: resfst.valueForKey("team_id") as! String)
            
            if(self.loadTeams) {
                tabObj.teams.append("\(first_name) \(last_name)")
                tabObj.teamIds.append(resfst.valueForKey("team_id") as! String)
                
            }
            println("Contents of res1 \(res1[i])")
        }
        self.loadTeams = false
        tabObj.teams = sorted(tabObj.teams, <)
        tabObj.teamIds = sorted(tabObj.teamIds, <)
        self.defaults.setObject(tabObj.teams, forKey: "teamNames")
        self.defaults.synchronize()
        
        
        self.defaults.setObject(tabObj.teamIds, forKey: "teamIds")
        
        self.defaults.synchronize()
        
        self.defaults.setObject(tabObj.teamIdsSM, forKey: "teamIdsSM")
        
        self.defaults.synchronize()
        
        
        self.defaults.setObject(tabObj.teamsSM, forKey: "teamsSM")
        
        self.defaults.synchronize()
        
        
        
    }


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //  self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let tabObj = self.tabBarController as! TabBarController
        tabObj.tableview = self
        self.defaults = NSUserDefaults(suiteName: "group.com.cepwin.BaseballLine")!
        var teamIds1 : [String]? = (self.defaults.objectForKey("teamIds") as? [String])
        var teams1 : [String]? = (self.defaults.objectForKey("teamNames") as? [String])
        var teamsSM : [String]? = (self.defaults.objectForKey("teamsSM") as? [String])
        var teamIdsSM : [String]? = (self.defaults.objectForKey("teamIdsSM") as? [String])
        if (teams1 != nil) {
            tabObj.teams = teams1!
            //  self.teams.sort($0 > $1)
            tabObj.teams = sorted(tabObj.teams, <)
            self.teams = tabObj.teams
            self.loadTeams = false
            
        } else {
            self.loadTeams = true
        }
        
        if(teamIds1   != nil) {
            tabObj.teamIds = teamIds1!
            //self.teamIds.sort($0 > $1)
            tabObj.teamIds = sorted(tabObj.teamIds, <)
            // self.teamIds = tabObj.teamIds
        }
        if(teamIdsSM   != nil) {
            tabObj.teamIdsSM = teamIdsSM!
            //self.teamIds.sort($0 > $1)
            tabObj.teamIdsSM = sorted(tabObj.teamIdsSM, <)
            // self.teamIdsSM = tabObj.teamIdsSM
            
        }
        if(teamsSM   != nil) {
            tabObj.teamsSM = teamsSM!
            //self.teamIds.sort($0 > $1)
            tabObj.teamsSM = sorted(tabObj.teamsSM, <)
            // self.teamsSM = tabObj.teamsSM
            
        }
        //change here
        getData()
       }
    
    func sortTeams() {
        let tabObj = self.tabBarController as! TabBarController
        self.teamsSM = tabObj.teamsSM
        self.teams = tabObj.teams
        self.teamIdsSM = tabObj.teamIdsSM
        self.teamIds = tabObj.teamIds
        
        if self.teamIdsSM.count > 0 {
            for k in 0...(self.teamIdsSM.count-1){
                self.teamIds = self.teamIds.filter{!contains([self.teamIdsSM[k]], $0)}
                self.teamIds.insert(self.teamIdsSM[k], atIndex: k)
                
                self.teams.filter{!contains([self.teamsSM[k]], $0)}
                self.teams.insert(self.teamsSM[k], atIndex: k)
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tabObj = self.tabBarController as! TabBarController
        
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let key = self.teamIds[indexPath.item] as String
                let object:[String:AnyObject] = self.teamDict2[key]!
                var keys:Array<String>  = Array(object.keys) as Array<String>
                (segue.destinationViewController as! DetailViewController).detailItem = object
            }
        }
    }
    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tabObj = self.tabBarController as! TabBarController
        return tabObj.teams.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        //let tabObj = self.tabBarController as! TabBarController
        
        cell.textLabel!.text = self.teams[indexPath.item] as NSString as String
        
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

 

}

