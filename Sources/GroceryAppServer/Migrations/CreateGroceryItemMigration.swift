//
//  CreateGroceryItemMigration.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 22/09/2025.
//

import Foundation
import Fluent

class CreateGroceryItemMigration:AsyncMigration, @unchecked Sendable {
    
    let table = "grocery_items"
    
    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema(table)
            .id()
            .field("title", .string, .required)
            .field("price",.double,.required)
            .field("quantity",.int, .required)
            .field("grocery_category_id",.uuid,.required,.references("grocery_categories", "id",onDelete: .cascade))
            .create()
        
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(table)
            .delete()
    }
    
    
    
}
