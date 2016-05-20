//
//  DoupQueueManager.swift
//  DoupQueue
//
//  Created by Milan Kamilya on 12/05/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Alamofire

public typealias ProgressBlock         = (percentage : Double) -> Void
public typealias CompletionBlock       = (location : NSURL?, error : NSError?) -> Void
public typealias CompletionBlockUpload = (result : Bool, error : NSError?) -> Void

public class DoupQueueManager: NSObject {

    // MARK:- PUBLIC PROPERTY
    public static let sharedManager = DoupQueueManager()
    
    
    // MARK: - PRIVATE PROPERTY
    private var downloadQueue: [DownloadTask]? = [DownloadTask]()
    private var currrentDownloadTask : DownloadTask?
    private var uploadQueue: [UploadTask]?     = [UploadTask]()
    private var currrentUploadTask : UploadTask?
    
    // MARK: - INIT METHOD
    private override init() {
        super.init()
        
    }
    
    // MARK: - SERVICE METHODS
    public func pushToDownloadQueue(url : String, progressHandler: ProgressBlock?, completionHandler: CompletionBlock?) -> String {
        
        // 1. Initialize Task
        // 2. Push into download queue
        // 3. Return token of task
        
        let task = DownloadTask(urlStr: url, onProgress: progressHandler, onCompletion: completionHandler)
        downloadQueue?.append(task!)
        self.startDownloading()
        
        
        return task!.token!
        
    }
    
    private func startDownloading() {
        
        // 1. Get a task from download queue
        // 2. Start downloading it.
        if self.currrentDownloadTask == nil || self.currrentDownloadTask?.state == .Completed || self.currrentDownloadTask?.state == .Failed {
            
            self.currrentDownloadTask = self.findInitiatedTaskToDownload()
            
            if self.currrentDownloadTask != nil {
                
                // Change State 
                self.currrentDownloadTask?.state = .Running
                
                let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
                let task = session.downloadTaskWithURL(self.currrentDownloadTask!.url!)
                
                task.resume()
            }
        }
    }
    
    public func pushToUploadQueue(url : String, dataToUpload : NSData, progressHandler: ProgressBlock?, completionHandler: CompletionBlockUpload?) -> String {
        
        // 1. Initialize Task
        // 2. Push into upload queue
        // 3. Return token of task
        
        let task = UploadTask(urlStr: url, data : dataToUpload, onProgress: progressHandler, onCompletion: completionHandler)
        uploadQueue?.append(task)
        self.startUploading()
        
        
        return task.token!
        
    }
    
    public func pushToUploadQueue(url : String, fileURL : NSURL, progressHandler: ProgressBlock?, completionHandler: CompletionBlockUpload?) -> String {
        
        // 1. Initialize Task
        // 2. Push into upload queue
        // 3. Return token of task
        
        let task = UploadTask(urlStr: url, fileURL: fileURL, onProgress: progressHandler, onCompletion: completionHandler)
        uploadQueue?.append(task)
        self.startUploading()
        
        
        return task.token!
        
    }
    
    private func startUploading() {
    
        if self.currrentUploadTask == nil || self.currrentUploadTask?.state == .Completed || self.currrentUploadTask?.state == .Failed {
            
            self.currrentUploadTask = self.findInitiatedTaskToUpload()
            
            if self.currrentUploadTask != nil {
                // Change State
                self.currrentUploadTask?.state = .Running
                
                Alamofire.upload(
                    .POST,
                    self.currrentUploadTask!.url!,
                    multipartFormData: { multipartFormData in
                        if let url = self.currrentUploadTask?.urlOfFile  {
                            multipartFormData.appendBodyPart(fileURL: url, name: "file")
                        } else {
                            multipartFormData.appendBodyPart(data: self.currrentUploadTask!.dataToUpload!, name: "file")
                        }
                    },
                    
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            upload.progress { bytesSend, totalBytesSent, totalBytesExpectedToSend in
                                
                                if self.currrentUploadTask != nil && self.currrentUploadTask?.progressHandler != nil  {

                                    if totalBytesExpectedToSend == 0 {
                                        self.currrentUploadTask!.progressHandler!(percentage: Double(totalBytesSent))
                                    } else {
                                        self.currrentUploadTask!.progressHandler!(percentage: Double(totalBytesSent*100/totalBytesExpectedToSend))
                                    }
                                }
                            }
                            upload.responseJSON { response in
                                if response.data == nil {
                                    self.currrentUploadTask?.state = .Completed
                                    if self.currrentUploadTask != nil && self.currrentUploadTask?.completionHandler != nil  {
                                        self.currrentUploadTask?.completionHandler!( result: true, error: nil)
                                    }
                                } else {
                                    self.currrentUploadTask?.state = .Failed
                                    if self.currrentUploadTask != nil && self.currrentUploadTask?.completionHandler != nil  {
                                        self.currrentUploadTask?.completionHandler!( result: false, error: response.result.error)
                                    }
                                }
                                self.startUploading()
                            }
                        case .Failure(let encodingError):
                            print(encodingError)
                        }
                    }
                )
                
                
                
                
//                
//                
//                let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
//                let session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
//                let request = NSMutableURLRequest(URL: self.currrentUploadTask!.url!)
//                request.HTTPMethod = "POST"
//                let task = session.uploadTaskWithRequest(request, fromData: self.currrentUploadTask!.dataToUpload!)
//                
//                task.resume()
                
            }
        }
        
    }
    
    // MARK: - UTILITY METHODS
    private func findInitiatedTaskToDownload() -> DownloadTask? {
        for task in self.downloadQueue! {
            if task.state == .Initiated {
                return task
            }
        }
        return nil
    }
    
    private func findInitiatedTaskToUpload() -> UploadTask? {
        for task in self.uploadQueue! {
            if task.state == .Initiated {
                return task
            }
        }
        return nil
    }
}


// MARK: - DOWNLOAD DELEGATE
extension DoupQueueManager : NSURLSessionDownloadDelegate {
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //log.info("\(bytesWritten) \(totalBytesWritten) \(totalBytesExpectedToWrite)")
        if self.currrentDownloadTask != nil && self.currrentDownloadTask?.progressHandler != nil  {
            if totalBytesExpectedToWrite == 0 {
                self.currrentDownloadTask!.progressHandler!(percentage: Double(totalBytesWritten))
            } else {
                self.currrentDownloadTask!.progressHandler!(percentage: Double(totalBytesWritten*100/totalBytesExpectedToWrite))
            }
        }
    }
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
    
        let documentsDirectoryURL =  NSFileManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first! as NSURL
        print("Finished downloading!")
        print(documentsDirectoryURL)
        
        // Here you can move your downloaded file
        do {
            try NSFileManager().moveItemAtURL(location, toURL: documentsDirectoryURL.URLByAppendingPathComponent((downloadTask.response?.suggestedFilename)!))
            self.currrentDownloadTask?.state = .Completed
            
            if self.currrentDownloadTask != nil && self.currrentDownloadTask?.completionHandler != nil  {
                self.currrentDownloadTask?.completionHandler!(location: documentsDirectoryURL.URLByAppendingPathComponent((downloadTask.response?.suggestedFilename)!), error: nil)
            }
            
        } catch let err as NSError{
            print(err)
            self.currrentDownloadTask?.state = .Failed

            // File Already Exists Error
            if err.code == 516 {
                self.currrentDownloadTask?.state = .Completed
                
                if self.currrentDownloadTask != nil && self.currrentDownloadTask?.completionHandler != nil  {
                    self.currrentDownloadTask?.completionHandler!(location: documentsDirectoryURL.URLByAppendingPathComponent((downloadTask.response?.suggestedFilename)!), error: nil)
                }

            } else {
                if self.currrentDownloadTask != nil && self.currrentDownloadTask?.completionHandler != nil  {
                    self.currrentDownloadTask?.completionHandler!(location: nil, error: err)
                }
            }
            
        }
        self.startDownloading()
        
    }
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        //log.info("Download resume")
    }
}


/*
extension DoupQueueManager : NSURLSessionDelegate {
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        //log.info("Upload :: \(bytesSent) \(totalBytesSent) \(totalBytesExpectedToSend)")
        
        if task.currentRequest?.HTTPMethod == "POST" {
            if totalBytesExpectedToSend == 0 {
                self.currrentUploadTask!.progressHandler!(percentage: Double(totalBytesSent))
            } else {
                self.currrentUploadTask!.progressHandler!(percentage: Double(totalBytesSent*100/totalBytesExpectedToSend))
            }
        }
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
    
        //log.info("Completed.")
        
        if task.currentRequest?.HTTPMethod == "POST" {
            if error == nil {
                self.currrentUploadTask?.state = .Completed
                if self.currrentUploadTask != nil && self.currrentUploadTask?.completionHandler != nil  {
                    self.currrentUploadTask?.completionHandler!( result: true, error: nil)
                }
            } else {
                self.currrentUploadTask?.state = .Failed
                if self.currrentUploadTask != nil && self.currrentUploadTask?.completionHandler != nil  {
                    self.currrentUploadTask?.completionHandler!( result: false, error: error)
                }
            }
            self.startUploading()
        }
        
    }
    
}
 */