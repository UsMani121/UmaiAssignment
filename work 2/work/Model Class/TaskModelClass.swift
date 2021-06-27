//
//  ModelClass.swift
//  work
//
//  Created by Apple on 24/06/2021.
//

import Foundation

class TaskModelClass : NSObject, Codable {
    
    var taskName : String
    var taskStatus : Bool = false
    
    init(taskName : String , taskStatus : Bool) {
        self.taskName = taskName
        self.taskStatus = taskStatus
    }
    
    init(taskName : String ) {
        self.taskName = taskName
    }
 
}
