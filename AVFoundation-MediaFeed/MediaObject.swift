//
//  Media.swift
//  AVFoundation-MediaFeed
//
//  Created by Brendon Crowe on 5/4/23.
//

import Foundation

// media object can be either a video or image
struct MediaObject {
    let imageData: Data?
    let videoURL: URL?
    let caption: String?
    let id = UUID().uuidString
    let createDate = Date()
}
