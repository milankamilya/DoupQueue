//
//  DownloadTask.swift
//  DoupQueue
//
//  Created by Milan Kamilya on 17/05/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class DownloadTask: Task {
    
    var completionHandler : CompletionBlock?
    
    init?(urlStr:String, onProgress: ProgressBlock?, onCompletion: CompletionBlock?) {
        super.init(urlStr: urlStr, onProgress: onProgress)
        completionHandler = onCompletion
    }
}
