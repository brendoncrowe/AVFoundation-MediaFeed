//
//  CoreDataManager.swift
//  AVFoundation-MediaFeed
//
//  Created by Brendon Crowe on 5/6/23.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    private var mediaObjects = [CDMediaObject]()
    
    // get access to the NSManagedObjectContext from AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createMediaObject(_ imageData: Data, videoURL: URL?) -> CDMediaObject {
      let mediaObject = CDMediaObject(entity: CDMediaObject.entity(), insertInto: context)
      mediaObject.createdDate = Date() // current date
      mediaObject.id = UUID().uuidString // unique string
      mediaObject.imageData = imageData // both video and image objects has an image
      if let videoURL = videoURL { // if exist, this means it's a video object
        // convert a URL to Data
        do {
          mediaObject.videoData = try Data(contentsOf: videoURL)
        } catch {
          print("failed to convert URL to Data with error: \(error)")
        }
      }
      
      // save the newly created mediaObject entity instance to the NSManagedObjectContext
      do {
        try context.save()
      } catch {
        print("failed to save newly created media object with error: \(error)")
      }
      return mediaObject
    }
    
    public func fetchMediaObjects() -> [CDMediaObject] {
        do {
            mediaObjects = try context.fetch(CDMediaObject.fetchRequest())
        } catch {
            print("could not fetch mediaObjects: \(error.localizedDescription)")
        }
        return mediaObjects
    }
    
    public func deleteMediaObject(_ object: CDMediaObject) -> Bool {
        var wasDeleted = false
        context.delete(object)
        do {
            try context.save()
            wasDeleted = true
        } catch {
            print("error deleting object: \(error.localizedDescription)")
        }
        return wasDeleted
    }
}
