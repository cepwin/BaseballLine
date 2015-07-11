//
//  tabBarController.swift
//  BaseballLine
//
//  Created by Wendy Sarrett on 4/18/15.
//  Copyright (c) 2015 Wendy Sarrett. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

  //  var teams : [String] = []
 //   var teamIds : [String] = []
    
    var teamsSM : [String] = []
    var teamIdsSM : [String] = []
    
    var teamAll : [String:String] = [String:String]()
    
    var tableview : MasterViewController? = nil
    
    var teamHandler : [String:String] = [String: String]()

    var sortOrder : Int = 0
    
   
}
