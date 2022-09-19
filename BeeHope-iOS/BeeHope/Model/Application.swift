import Foundation
import UIKit

struct Application {
    public let id: Int?
    public let animal: String
    public let description: String?
    public let location: String?
    public var photo: UIImage?
    public let photoLink: String?
    public let status: String?
    
    init?(animal: String?, description: String?, location: String?, photoLink: String?) {
        guard let animal, let location else { 
            return nil
        }
        self.id = 0
        self.animal = animal
        self.description = description
        self.location = location
        self.photoLink = photoLink
        self.status = nil
        self.photo = nil
    }
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
              let animal = json["name"] as? String,
              let location = json["coordinates"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.animal = animal
        self.description = json["description"] as? String
        self.location = location 
        self.status = json["status"] as? String
        self.photoLink = json["image"] as? String
        self.photo = nil
    }
}
