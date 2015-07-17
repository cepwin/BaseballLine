//
//  MasterViewController.swift
//  BaseballLine
//
//  Created by Wendy Sarrett on 6/14/15.
//  Copyright (c) 2015 Wendy Sarrett. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    typealias TeamTuple = (teamName : String, teamId : String, teamDivRank : String)

    var defaultBG = UIColor()
    var objects = [AnyObject]()

    
 
    var teamDictSM:[String:[String:AnyObject]] = [String:[String:AnyObject]]()
    
    var teamDict2:[String:[String:AnyObject]] = [String:[String:AnyObject]]()
    
    
    
    var teamIdsSM:[String] = [String]()
    var teamsSM:[String] = [String]()
    
    var teamT : [(key : String, value : String)] = []

    let confDiv : [String: Int] = ["NLE" : 1, "NLC" : 2, "NLW" : 3, "ALE" : 4, "ALC" : 5, "ALW" : 6]

    
    @IBOutlet var teamsTable: UITableView!
    
    let ALPHA = 0
    let STANDINGS = 1
    
    
    var parsedObject  : NSDictionary = NSDictionary()
    var defaults : NSUserDefaults = NSUserDefaults()
    var sortOrder = 0
    
    @IBOutlet weak var updateData: UINavigationItem!
    
    @IBAction func update(sender: AnyObject) {
        getData()
        let alert = UIAlertView()
        alert.title = "New Data"
        alert.message = "Data Loaded"
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("Head") as! DivisionHeaderCell
       // headerCell.backgroundColor = UIColor.cyanColor()
        let tabObj = self.tabBarController as! TabBarController
        
        if(tabObj.sortOrder == 0) {
            headerCell.textLabel?.text = "Alphabetical"
        }
        else {
            switch (section) {
            case 0:
                headerCell.textLabel?.text = "National League East";
            case 1:
                headerCell.textLabel?.text = "National League Central";
            case 2:
                headerCell.textLabel?.text = "National League West";
            case 3:
                headerCell.textLabel?.text = "American League East";
            case 4:
                headerCell.textLabel?.text = "American League Central";
            case 5:
                headerCell.textLabel?.text = "American League West";
            default:
                headerCell.textLabel?.text = "Division"
            }
        }
        return headerCell
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
        if tabObj.teamHandler.count > 0 {
//            loadTeams = false
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
            
           // if(self.loadTeams) {
                let name = "\(first_name)|\(last_name)"
                let id = resfst.valueForKey("team_id") as! String
                let conf = (resfst.valueForKey("conference")! as! String)
                let div = (resfst.valueForKey("division") as! String)
                let rank: NSInteger = resfst.valueForKey("rank") as! NSInteger
                let sort1 = self.confDiv[conf+div]!
                let sort : NSString = "\(sort1)\(rank)"
                tabObj.teamHandler.updateValue(sort as! String, forKey: "\(first_name)|\(last_name);\(id)")

           // }
            println("Contents of res1 \(res1[i])")
        }
     //   self.loadTeams = false
        if(self.sortOrder == STANDINGS ) {
            self.teamT = Array(tabObj.teamHandler).sorted({$0.1 < $1.1})
        } else {
            self.teamT = Array(tabObj.teamHandler).sorted({$0.0 < $1.0})

        }
        
        self.defaults.setObject(tabObj.teamIdsSM, forKey: "teamIdsSM")
        
        self.defaults.synchronize()
        
        
        self.defaults.setObject(tabObj.teamsSM, forKey: "teamsSM")
        
        self.defaults.synchronize()
        
        self.defaults.setObject(tabObj.teamHandler, forKey: "teamDictionary")
        
        self.defaults.synchronize()

        
    }


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //  self.navigationItem.leftBarButtonItem = self.editButtonItem()
        defaultBG = UIColor(red: 0.80043935775756836, green: 0.80043935775756836, blue: 1, alpha: 1)
        let tabObj = self.tabBarController as! TabBarController
        tabObj.tableview = self
        self.defaults = NSUserDefaults(suiteName: "group.com.cepwin.BaseballLine")!
        var teamsSM : [String]? = (self.defaults.objectForKey("teamsSM") as? [String])
        var teamIdsSM : [String]? = (self.defaults.objectForKey("teamIdsSM") as? [String])
        var teamTup :  [String:String]? =  (self.defaults.objectForKey("teamDictionary") as? [String : String])
        let so : Int?  = self.defaults.objectForKey("sortOrder") as? Int
        if((so) != nil)  {
            self.sortOrder = so!
        } else {
        self.sortOrder  = 0
        }
        if(teamTup != nil) {
            tabObj.teamHandler = teamTup!
            if(self.sortOrder == STANDINGS) {
           self.teamT =  Array(tabObj.teamHandler).sorted({$0.1 < $1.1})
            } else {
                self.teamT =  Array(tabObj.teamHandler).sorted({$0.0 < $1.0})
            }
//            self.loadTeams = false

        }else {
  //          self.loadTeams = true
        }
        tabObj.sortOrder = self.sortOrder
        if(teamIdsSM   != nil) {
            tabObj.teamIdsSM = teamIdsSM!
            tabObj.teamIdsSM = sorted(tabObj.teamIdsSM, <)
        }
        if(teamsSM   != nil) {
            tabObj.teamsSM = teamsSM!
            tabObj.teamsSM = sorted(tabObj.teamsSM, <)
            
        }
        //change here
        getData()
       }
    
    func sortTeams() {
        let tabObj = self.tabBarController as! TabBarController
        self.sortOrder = tabObj.sortOrder
        self.teamsSM = tabObj.teamsSM
        self.teamIdsSM = tabObj.teamIdsSM
         if(self.sortOrder == self.ALPHA) {
            self.teamT = Array(tabObj.teamHandler).sorted({$0.0 < $1.0})
            if self.teamIdsSM.count > 0 {
            for k in 0...(self.teamIdsSM.count-1){
                var filterStr = "\(self.teamsSM[k]);\(self.teamIdsSM[k])"
                var saveItem = teamT.filter({$0.key == filterStr})
                self.teamT = teamT.filter({$0.key != filterStr})
                self.teamT.insert(saveItem[0], atIndex: k)

                
                }
            }
        } else {
            self.teamT = Array(tabObj.teamHandler).sorted({$0.1 < $1.1})

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
        var row = 0
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if(tabObj.sortOrder == 0) {
                    row = indexPath.item
                    
                } else {
                    row = indexPath.item+(indexPath.section*5)
                }

                let key = nameToId(self.teamT[row].key as String)
                let object:[String:AnyObject] = self.teamDict2[key]!
                var keys:Array<String>  = Array(object.keys) as Array<String>
                (segue.destinationViewController as! DetailViewController).detailItem = object
            }
        }
    }
    
    func nameToId(name : String) ->String {
        var id = split(name) {$0 == ";"}[1]
         return id
    }
    
    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let tabObj = self.tabBarController as! TabBarController
        if(tabObj.sortOrder == 0) {
            return 1
        }
        else {
            return 6
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tabObj = self.tabBarController as! TabBarController
        if(tabObj.sortOrder==0) {
            return tabObj.teamHandler.count
        } else {
            return 5
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let tabObj = self.tabBarController as! TabBarController
        if(self.teamT.count > 0) {
            var teamPair = []
            if(tabObj.sortOrder == 1){
                teamPair = split(teamT[indexPath.item+(indexPath.section*5)].key) {$0 == ";"}
            } else {
                teamPair = split(teamT[indexPath.item].key) {$0 == ";"}
            }
             let saveItem = tabObj.teamIdsSM.filter({$0 == teamPair[1] as! String})
            if(saveItem.count > 0) {
                cell.backgroundColor = UIColor.redColor()
            } else
            {
                cell.backgroundColor = defaultBG
            }
            var teamName = teamPair[0] as! String
            let rowStr = teamName.stringByReplacingOccurrencesOfString("|", withString: " ", options: NSStringCompareOptions.CaseInsensitiveSearch)

            cell.textLabel!.text = rowStr as NSString as String
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

 

}

