// https://github.com/Quick/Quick

import Quick
import Nimble
import DoupQueue

class TableOfContentsSpec: QuickSpec {
    
    override func spec() {
        
        // 1. Download queue test
        describe("Download queue test"){
            
            var downloadCompletionIndex = -1
            
            it("1st Download Asynchronous", closure: {
                
                waitUntil(timeout: 180, action: { (done) in
                    DoupQueueManager.sharedManager.pushToDownloadQueue("http://cdn.wccftech.com/wp-content/uploads/2015/06/os-x-10.11-wallpaper.jpg", progressHandler: { (percentage) in
                        
                        downloadCompletionIndex = 0
                    }) { (location, error) in
                        
                        expect("0") == "\(downloadCompletionIndex)"
                        done()
                    }
                })
                
            })
            
            
            it("2nd Download Asynchronous", closure: {
                
                waitUntil(timeout: 180, action: { (done) in
                    DoupQueueManager.sharedManager.pushToDownloadQueue("http://www.webextensionline.com/wp-content/uploads/Natural-summer-pink-flower.jpg", progressHandler: { (percentage) in
                        
                        downloadCompletionIndex = 1
                    }) { (location, error) in
                        
                        expect("1") == "\(downloadCompletionIndex)"
                        done()
                    }
                })
                
            })
            
            it("3rd Download Asynchronous", closure: {
                
                waitUntil(timeout: 180, action: { (done) in
                    DoupQueueManager.sharedManager.pushToDownloadQueue("http://wallpaperswide.com/download/nature_221-wallpaper-2880x1800.jpg", progressHandler: { (percentage) in
                        
                        downloadCompletionIndex = 2
                    }) { (location, error) in
                        
                        expect("2") == "\(downloadCompletionIndex)"
                        done()
                    }
                })
                
            })
            
        }
        
        
        // 2. Upload queue test using uploading already downloaded data
        // 3. Simultaneous testing of download & upload testing.
        
        
    }
 
}
