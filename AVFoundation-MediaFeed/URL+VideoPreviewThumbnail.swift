//
//  URL+VideoPreviewThumbnail.swift
//  AVFoundation-MediaFeed
//
//  Created by Brendon Crowe on 5/5/23.
//

import UIKit
import AVFoundation

enum URLError: String, Error {
    case imageError = "Could not create a thumbnail image"
}

extension URL {
    
    public func videoPreviewThumbnail() async throws -> UIImage {
        // create an AVAsset instance
        let asset = AVAsset(url: self) // self refers to the URL instance (e.g mediaObject.videoURL.videoPreviewThumbnail())
        
        // The AVAssetImageGenerator is an AVFoundation class that converts a given media url to an image
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        
        // maintain the aspect ratio of the video
        assetGenerator.appliesPreferredTrackTransform = true
        
        // create a timestamp of the desired image frame in the video
        // use CMTime (CoreMedia) to generate the time stamp
        let timestamp = CMTime(seconds: 3, preferredTimescale: 60) // get first second of video
        
        do {
            let (image, _) = try await assetGenerator.image(at: timestamp)
            let thumbnailImage = UIImage(cgImage: image)
            return thumbnailImage
        } catch {
            throw URLError.imageError
        }
    }
}
