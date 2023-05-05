//
//  ViewController.swift
//  AVFoundation-MediaFeed
//
//  Created by Brendon Crowe on 5/4/23.
//

import UIKit
import AVKit // contains AVPLayerViewController for video playback
import AVFoundation // video playback is done on a CALayer, which all views are backed by

class MediaFeedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var videoButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    
    private let cellId = "mediaCell"
    private let headerId = "headerView"
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pickerController.delegate = self
        return pickerController
    }()
    
    private var mediaObjects = [MediaObject]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureCV()
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            videoButton.isEnabled = false
        }
    }
    
    private func configureCV() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction func videoButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
}

// MARK: CollectionView Delegates
extension MediaFeedViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MediaCell else {
            fatalError("could not dequeue a MediaCell")
        }
        let mediaObject = mediaObjects[indexPath.row]
        cell.configureCell(for: mediaObject)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: view.frame.height * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as? CustomHeader else {
            fatalError("could not load the header")
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaObject = mediaObjects[indexPath.row]
        guard let videoURL = mediaObject.videoURL else { return }
        let playerController = AVPlayerViewController() // comes from AVKit
        let player = AVPlayer(url: videoURL)
        playerController.player = player
        present(playerController, animated: true) {
            // play video automatically
            player.play()
        }
    }
}

extension MediaFeedViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // info dictionary keys
        // InfoKey.originalImage - UIImage
        // InfoKey.mediaType - String
        // InfoKey.mediaURL - URL
        let image = "public.image"
        let movie = "public.movie"
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else { return }
        
        switch mediaType {
        case image:
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imageData = originalImage.jpegData(compressionQuality: 1.0) {
                let mediaObject = MediaObject(imageData: imageData, videoURL: nil, caption: nil)
                mediaObjects.append(mediaObject)
            }
        case movie:
            if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                let mediaObject = MediaObject(imageData: nil, videoURL: videoURL, caption: nil)
                mediaObjects.append(mediaObject)
            }
        default:
            print("unsupported media type")
        }
        print("mediaType: \(mediaType)")
        picker.dismiss(animated: true)
    }
}
