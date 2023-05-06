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
    
    public func createMediaObject(_ imageData: Data, _ videoURL: URL?) {
        let mediaObject = CDMediaObject(entity: CDMediaObject.entity(), insertInto: context)
        mediaObject.createdDate = Date()
        mediaObject.id = UUID().uuidString
        mediaObject.imageData = imageData
        if let videoURL = videoURL {
            do {
                mediaObject.videoData = try Data(contentsOf: videoURL)
            } catch {
                print("error converting url to data: \(error.localizedDescription)")
            }
        }
        do {
            try context.save()
        } catch {
            print("there was an error creating an object: \(error.localizedDescription)")
        }
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
