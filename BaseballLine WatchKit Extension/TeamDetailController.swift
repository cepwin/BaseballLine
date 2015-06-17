//
//  TeamDetailConrollerInterfaceController.swift
//  BaseballLine
//
//  Created by Wendy Sarrett on 5/8/15.
//  Copyright (c) 2015 Wendy Sarrett. All rights reserved.
//

import WatchKit
import Foundation


class TeamDetailController: WKInterfaceController {

    var teamDetail = [String:AnyObject]()
    
    @IBOutlet weak var teamDetailTable: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.teamDetail = (context as? [String:AnyObject])!
        loadTeams()
    }
    
    private func loadTeams() {
        self.teamDetailTable.setNumberOfRows(self.teamDetail.count, withRowType: "TeamDetailRowController")
        for (index, team) in enumerate(self.teamDetail) {
            let x = self.teamDetailTable.numberOfRows
            let row = self.teamDetailTable.rowControllerAtIndex(index) as? TeamDetailRowController
            let stVal = team.1 as! String
            var stName = team.0 as String
            stName = stName.stringByReplacingOccurrencesOfString("_", withString: " ", options: NSStringCompareOptions.CaseInsensitiveSearch)
            row!.detailRowLabel.setText("\(stName): \(stVal)")

        }
        
    }
   

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
