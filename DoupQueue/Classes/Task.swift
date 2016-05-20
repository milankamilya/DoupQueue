//
//  Task.swift
//  DoupQueue
//
//  Created by Milan Kamilya on 12/05/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

/**
 Task State will be used for downloading and uploading task's state.
 For each task should have this property.
 
 - Queued:    Task / file uploading or downloading is waiting in a Queue
 - Running:   Task is currently running
 - Failed:    Task has failed due to any reason
 - Completed: Task has completed
 - Cancelled: Task has been cancelled
 - Paused:    Task has been paused
 */
enum TaskState : String {
    case Initiated = "Initiated"
    case Queued    = "Queued"
    case Running   = "Running"
    case Failed    = "Failed"
    case Completed = "Completed"
    case Cancelled = "Cancelled"
    case Paused    = "Paused"
}


/// Task is classes which will be used to create object for download and upload
class Task {
    
    var url : NSURL?
    var fileName : String?
    var state : TaskState?
    var token : String?
    
    var progressHandler : ProgressBlock?
    
    private let tokenLength = 20
    
    // MARK: - INITIALIZATION
    init(urlStr:String, onProgress: ProgressBlock? ) {
        
        url = NSURL(string: urlStr)
        progressHandler = onProgress
        self.state = .Initiated
        token = randomString(tokenLength)
    }
    
    
    // MARK: - UTILITY
    func randomString(length: Int) -> String {
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersArray : [Character] = Array(charactersString.characters)
        
        var string = ""
        for _ in 0..<length {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        
        return string
    }

}
