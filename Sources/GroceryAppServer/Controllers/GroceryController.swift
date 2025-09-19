//
//  GroceryController.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 19/09/2025.
//

import Foundation
import Vapor
import Fluent

class GroceryController:RouteCollection, @unchecked Sendable {
    
    
    func boot(routes: any RoutesBuilder) throws {
        
        let api = routes.grouped("api","users",":userId")
        
        
            //POST: Saving GroceryCategory
            // /api/users/:userId/grocery-categories
        api.post("grocery-categories", use: saveGroceryCategories)
            
    }
    
    func saveGroceryCategories(req:Request) async throws -> GroceryCategoryResponseDTO {
        
        // validate the request DTO instead of the model
        try GroceryCategoryRequestDTO.validate(content: req)
       
        //decode
        guard let userId = req.parameters.get("userId",as:UUID.self) else {
            throw Abort(.notFound)
        }
        
        let grocery = try req.content.decode(GroceryCategoryRequestDTO.self)
        
        // save
        let groceryCategory = GroceryCategory(title: grocery.title, colorCode: grocery.colorCode, userID: userId)
        
        try await groceryCategory.save(on: req.db)
        
        // response DTO
        return try GroceryCategoryResponseDTO(id: groceryCategory.requireID(), title: groceryCategory.title, colorCode: groceryCategory.colorCode)
    }
}