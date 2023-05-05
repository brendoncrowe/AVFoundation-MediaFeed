//
//  CustomMediaCell.swift
//  AVFoundation-MediaFeed
//
//  Created by Brendon Crowe on 5/4/23.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    public func configureCell(for mediaObject: MediaObject) {
        if let imageData = mediaObject.imageData {
            mediaImageView.image = UIImage(data: imageData)
        }
        if let videoURL = mediaObject.videoURL {
            videoURL.videoPreviewThumbnail { [weak self] result in
                switch result {
                case .failure(let error):
                    print("error creating thumbnail image: \(error)")
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.mediaImageView.image = image
                    }
                }
            }
        }
    }
}
