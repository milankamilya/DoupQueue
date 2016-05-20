//
//  UploadTask.swift
//  DoupQueue
//
//  Created by Milan Kamilya on 17/05/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class UploadTask: Task {

    var dataToUpload : NSData?
    var urlOfFile : NSURL?
    var completionHandler : CompletionBlockUpload?

    init(urlStr:String, data : NSData, onProgress: ProgressBlock?, onCompletion: CompletionBlockUpload?) {
        super.init(urlStr: urlStr, onProgress: onProgress)
        dataToUpload = data
        urlOfFile = nil
        completionHandler = onCompletion
    }
    
    init(urlStr:String, fileURL : NSURL, onProgress: ProgressBlock?, onCompletion: CompletionBlockUpload?) {
        super.init(urlStr: urlStr, onProgress: onProgress)
        dataToUpload = nil
        urlOfFile = fileURL
        completionHandler = onCompletion
    }
}
