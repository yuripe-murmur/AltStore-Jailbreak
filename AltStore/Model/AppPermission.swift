//
//  AppPermission.swift
//  AltStore
//
//  Created by Riley Testut on 7/23/19.
//  Copyright © 2019 Riley Testut. All rights reserved.
//

import CoreData
import UIKit

extension ALTAppPermissionType
{
    var localizedShortName: String? {
        switch self
        {
        case .photos: return NSLocalizedString("Photos", comment: "")
        case .backgroundAudio: return NSLocalizedString("Audio (BG)", comment: "")
        case .backgroundFetch: return NSLocalizedString("Fetch (BG)", comment: "")
        default: return nil
        }
    }
    
    var localizedName: String? {
        switch self
        {
        case .photos: return NSLocalizedString("Photos", comment: "")
        case .backgroundAudio: return NSLocalizedString("Background Audio", comment: "")
        case .backgroundFetch: return NSLocalizedString("Background Fetch", comment: "")
        default: return nil
        }
    }
    
    var icon: UIImage? {
        switch self
        {
        case .photos: return UIImage(named: "PhotosPermission")
        case .backgroundAudio: return UIImage(named: "BackgroundAudioPermission")
        case .backgroundFetch: return UIImage(named: "BackgroundFetchPermission")
        default: return nil
        }
    }
}

@objc(AppPermission)
class AppPermission: NSManagedObject, Decodable, Fetchable
{
    /* Properties */
    @NSManaged var type: ALTAppPermissionType
    @NSManaged var usageDescription: String
    
    /* Relationships */
    @NSManaged private(set) var app: StoreApp!
    
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?)
    {
        super.init(entity: entity, insertInto: context)
    }
    
    private enum CodingKeys: String, CodingKey
    {
        case type
        case usageDescription
    }
    
    required init(from decoder: Decoder) throws
    {
        guard let context = decoder.managedObjectContext else { preconditionFailure("Decoder must have non-nil NSManagedObjectContext.") }
        
        super.init(entity: AppPermission.entity(), insertInto: nil)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.usageDescription = try container.decode(String.self, forKey: .usageDescription)
        
        let rawType = try container.decode(String.self, forKey: .type)
        self.type = ALTAppPermissionType(rawValue: rawType)
        
        context.insert(self)
    }
}

extension AppPermission
{
    @nonobjc class func fetchRequest() -> NSFetchRequest<AppPermission>
    {
        return NSFetchRequest<AppPermission>(entityName: "AppPermission")
    }
}
