//
//  Extensions.swift
//  GameOfChats
//
//  Created by Frank  on 3/7/18.
//  Copyright © 2018 Frank . All rights reserved.
//

import UIKit

// forced us to use NSString here, this just caches like a dictionary I think
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        // blank out image to get rid of cell reuse bugs
        self.image = nil
        
        // Check cache for image before heading to the network, don't download unless you need to
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        // otherwise fire off new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            // download failed
            if error != nil {
                print(error.debugDescription)
                return
            }
            // send back to the main Queue
            DispatchQueue.main.async {
                // successful download, takes some time though
                if let downloadedImage = UIImage(data: data!) {
                    // kind of like a dictionary I think
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    // set the image
                    self.image = downloadedImage
                }
            }
        }).resume()
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

