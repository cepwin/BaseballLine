//
//  TeamHandler.swift
//  BaseballLine
//
//  Created by Wendy Sarrett on 6/27/15.
//  Copyright (c) 2015 Wendy Sarrett. All rights reserved.
//

import Foundation


struct TeamHandler {
    
     final class TeamInfo {
        var teamName : String = ""
        var teamId : String = ""
        var teamDiv: String = ""
    }
    
    let confDiv : [String: Int] = ["NLE" : 1, "NLC" : 2, "NLW" : 3, "ALE" : 4, "ALC" : 5, "ALW" : 6]

    var defaults = NSUserDefaults(suiteName: "group.com.cepwin.BaseballLine")!
    
    typealias TeamTuple = (teamName : String, teamId : String, teamDivRank : String)
    
    
    var teamImpl : [TeamTuple] = []
    
   // var teamDictionary : [String : TeamInfo]()
    

    
    func getTuple() -> [TeamTuple]? {
        var teamDictionary = self.defaults.objectForKey("teamDictionary") as? NSDictionary
        if(teamDictionary != nil) {
            var tuple = dictionaryToTuple(teamDictionary!)
            return tuple
        }
        return nil
    }
    
    func saveTuple(tuple : [TeamTuple]) {
        var dictionary  = tupleToDictionary(tuple)
        self.defaults.setObject(dictionary, forKey: "teamDictionary")
        self.defaults.synchronize()
    }

    
    mutating func addTuple(teamName : String, teamId : String, teamRank : NSInteger, teamConference: String, teamDivision : String) {
        let conf:String = teamConference + teamDivision
        var teamDiv : String = "\(self.confDiv[conf]!)\(teamRank)"
        self.teamImpl.append(teamId, teamDiv)
    }
    
    func tupleToDictionary(tuple : [TeamTuple]) -> [String:TeamInfo] {
        var newDictionary : [String:TeamInfo] = [String:TeamInfo]()
        for(teamName, teamId, teamDivRank) in tuple {
            var newStruct = TeamInfo()
            newStruct.teamName = teamName
            newStruct.teamId = teamId
            newStruct.teamDiv = teamDivRank
            var error:NSError! = nil
             newDictionary.updateValue(newStruct, forKey: teamId)
            }
        return newDictionary
    }
    
    func dictionaryToTuple(dictionary : NSDictionary)-> [TeamTuple] {
        var newTuple : [TeamTuple] = []
        for(teamId, teamInfo) in dictionary {
            let ti = teamInfo as! TeamInfo
            newTuple.append((ti.teamName, ti.teamId, ti.teamDiv))
        }
        return newTuple
    }
}

    

