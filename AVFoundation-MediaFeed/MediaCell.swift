//
//  CustomMediaCell.swift
//  AVFoundation-MediaFeed
//
//  Created by Brendon Crowe on 5/4/23.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    public func configureCell(for mediaObject: CDMediaObject) {
        if let imageData = mediaObject.imageData {
            mediaImageView.image = UIImage(data: imageData)
        }
        Task { // Task is called in a non-asynchronous environment
            if let videoURL = mediaObject.videoData?.convertToURL() {
                let image = try await videoURL.videoPreviewThumbnail()
                mediaImageView.image = image
            }
        }
    }
}
