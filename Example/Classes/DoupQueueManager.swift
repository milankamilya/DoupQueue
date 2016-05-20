//
//  DoupQueueManager.swift
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
    case Queued    = "Queued"
    case Running   = "Running"
    case Failed    = "Failed"
    case Completed = "Completed"
    case Cancelled = "Cancelled"
    case Paused    = "Paused"
}

class DoupQueueManager: NSObject {

    // MARK:- PUBLIC PROPERTY
    static var sharedManager = DoupQueueManager()
    
    
    // MARK: - PRIVATE PROPERTY
    
    
    // MARK: - INIT METHOD
    private override init() {
        super.init()
        
        print("Hello World")
    }
    
    // MARK: - SERVICE METHODS
    func printLog()  {
        
    }
    
    
    // MARK: - UTILITY METHODS
    
}
