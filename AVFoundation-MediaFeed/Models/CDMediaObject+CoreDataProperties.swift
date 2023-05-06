//
//  CDMediaObject+CoreDataProperties.swift
//  AVFoundation-MediaFeed
//
//  Created by Brendon Crowe on 5/6/23.
//
//

import Foundation
import CoreData


extension CDMediaObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMediaObject> {
        return NSFetchRequest<CDMediaObject>(entityName: "CDMediaObject")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var videoData: Data?
    @NSManaged public var caption: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var id: String?

}
