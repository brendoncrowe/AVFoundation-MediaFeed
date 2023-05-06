//
//  DataExtension.swift
//  AVFoundation-MediaFeed
//
//  Created by Brendon Crowe on 5/6/23.
//

import Foundation


extension Data {
    
    public func convertToURL() -> URL? {
        // create a temporary url
        // NSTemporaryDirectory() - stores temporary files, which get deleted as need by the os
        // when wanting to play back the video, there needs to be a url pointing to the video storage location
        // AVPlayer needs a url pointing to a location on Disk
        let tempURL = URL(filePath: NSTemporaryDirectory()).appending(path: "video").appendingPathExtension(".mp4")
        do {
            try self.write(to: tempURL, options: .atomic)
            return tempURL
        } catch {
            print("failed to write video data to temporary file: \(error)")
        }
        return nil
    }
}
