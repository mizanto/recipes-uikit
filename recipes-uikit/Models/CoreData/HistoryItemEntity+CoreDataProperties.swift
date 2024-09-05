//
//  HistoryItemEntity+CoreDataProperties.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 5.09.2024.
//
//

import Foundation
import CoreData


extension HistoryItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryItemEntity> {
        return NSFetchRequest<HistoryItemEntity>(entityName: "HistoryItemEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var mealName: String?
    @NSManaged public var date: Date?

}

extension HistoryItemEntity : Identifiable {

}
