//
//  IngredientEntity+CoreDataClass.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 5.09.2024.
//
//

import Foundation
import CoreData


@objc(IngredientEntity)
public class IngredientEntity: NSManagedObject, NSSecureCoding {
    
    // MARK: - NSSecureCoding support
    public static var supportsSecureCoding: Bool = true

    // MARK: - NSSecureCoding
    required convenience public init?(coder: NSCoder) {
        let context = CoreDataStack.shared.context
        
        guard let entity = NSEntityDescription.entity(forEntityName: "IngredientEntity", in: context) else {
            return nil
        }
        
        self.init(entity: entity, insertInto: context)
        
        // Decode properties
        self.name = coder.decodeObject(of: NSString.self, forKey: "name") as String? ?? ""
        self.measure = coder.decodeObject(of: NSString.self, forKey: "measure") as String? ?? ""
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(measure, forKey: "measure")
    }
}
