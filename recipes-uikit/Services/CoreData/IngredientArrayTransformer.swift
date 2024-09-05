//
//  IngredientArrayTransformer.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 5.09.2024.
//

import Foundation

@objc(IngredientArrayTransformer)
class IngredientArrayTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let ingredients = value as? [IngredientEntity] else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: ingredients, requiringSecureCoding: true)
            return data as NSData // Приведение к NSData
        } catch {
            print("Failed to encode ingredients: \(error)")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let ingredients = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, IngredientEntity.self], from: data) as? [IngredientEntity]
            return ingredients
        } catch {
            print("Failed to decode ingredients: \(error)")
            return nil
        }
    }
}
