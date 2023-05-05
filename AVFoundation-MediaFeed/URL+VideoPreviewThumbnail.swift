//
//  URL+VideoPreviewThumbnail.swift
//  AVFoundation-MediaFeed
//
//  Created by Brendon Crowe on 5/5/23.
//

import UIKit
import AVFoundation

// ** may want to refactor the below extension so as to not be using a completion handler. i.e simplify

extension URL {
    
    public func videoPreviewThumbnail(completion: @escaping(Result<UIImage, Error>) ->()) {
        // create an AVAsset instance
        let asset = AVAsset(url: self) // self refers to the URL instance (e.g mediaObject.videoURL.videoPreviewThumbnail())
        
        // The AVAssetImageGenerator is an AVFoundation class that converts a given media url to an image
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        
        // maintain the aspect ratio of the video
        assetGenerator.appliesPreferredTrackTransform = true
        
        // create a timestamp of the desired image frame in the video
        // use CMTime (CoreMedia) to generate the time stamp
        let timestamp = CMTime(seconds: 5, preferredTimescale: 60) // get first second of video
        
        assetGenerator.generateCGImageAsynchronously(for: timestamp) { cgImage, _, error in
            if let error = error {
                print("There was an error generating the photo")
                completion(.failure(error))
            }
            if let cgImage = cgImage {
                let image = UIImage(cgImage: cgImage)
                completion(.success(image))
            }
        }
    }
}

