//
//  CustomHeader.swift
//  AVFoundation-MediaFeed
//
//  Created by Brendon Crowe on 5/4/23.
//

import UIKit

class CustomHeader: UICollectionReusableView {
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .systemCyan.withAlphaComponent(0.6)
    }
}
