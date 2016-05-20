//
//  ViewController.swift
//  DoupQueue
//
//  Created by Milan Kamilya on 05/11/2016.
//  Copyright (c) 2016 Milan Kamilya. All rights reserved.
//

import UIKit
import Alamofire
import DoupQueue

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO:- FBSnapshotTestCase need to be added
        setenv("XcodeColors", "YES", 0)
        
        
        DoupQueueManager.sharedManager.pushToDownloadQueue("http://cdn.wccftech.com/wp-content/uploads/2015/06/os-x-10.11-wallpaper.jpg", progressHandler: { (percentage) in
            
            //print("percentage : \(percentage)")
            
            }) { (location, error) in
       
                
        }
        
        DoupQueueManager.sharedManager.pushToDownloadQueue("http://www.webextensionline.com/wp-content/uploads/Natural-summer-pink-flower.jpg", progressHandler: { (percentage) in
                //print("percentage 2nd : \(percentage)")
            }) { (location, error) in

                
        }
        let documentsDirectoryURL =  NSFileManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first! as NSURL
        
        let fileURL = documentsDirectoryURL.URLByAppendingPathComponent("Natural-summer-pink-flower.jpg")
        DoupQueueManager.sharedManager.pushToUploadQueue("http://192.168.0.29:3005/fileUpload", fileURL: fileURL, progressHandler: { (percentage) in
            log.info("upload percentage :: \(percentage)")
            }) { (result, error) in
                if result {
                    log.info("upload successful")
                } else {
                    log.info("upload failed")
                }
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
     
    }

}

