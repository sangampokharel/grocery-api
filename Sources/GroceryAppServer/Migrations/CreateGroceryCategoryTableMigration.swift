//
//  CreateGroceryCategoryTableMigration.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 19/09/2025.
//

import Vapor
import Fluent

struct CreateGroceryCategoryTableMigration:AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("grocery_categories").id()
            .field("title",.string,.required)
            .field("color_code",.string,.required)
            .field("user_id",.uuid,.required,.references("users", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("grocery_categories").delete()
    }
}
