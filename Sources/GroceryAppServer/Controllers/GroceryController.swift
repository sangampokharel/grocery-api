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
        
        //GET: TO get the list of categories of particular users
        api.get("grocery-categories",use:getGroceryCategoriesByUser)
        
        //Delete: Delete grocery
        // /api/users/:userId/grocery-categories/:groceryId
        api.delete("grocery-categories", ":groceryCategoryId", use: deleteGroceryCategory)
        
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
    
    
    func deleteGroceryCategory(req:Request) async throws -> GroceryCategoryResponseDTO {
        
       
        guard let userId = req.parameters.get("userId",as:UUID.self),
              let groceryId = req.parameters.get("groceryCategoryId",as:UUID.self) else {
            throw Abort(.notFound)
        }
      
       guard let groceryCategory = try await GroceryCategory.query(on: req.db)
            .filter(\.$user.$id == userId)
            .filter(\.$id == groceryId)
            .first() else {
           
           throw Abort(.notFound)
       }
        
        try await groceryCategory.delete(on: req.db)
        
        return GroceryCategoryResponseDTO(id: try groceryCategory.requireID(), title: groceryCategory.title, colorCode: groceryCategory.colorCode)
        
    }
    
    func getGroceryCategoriesByUser(req:Request) async throws -> [GroceryCategoryResponseDTO] {
        // get the user id
        guard let userId = req.parameters.get("userId",as:UUID.self) else {
            throw Abort(.notFound)
        }
        
        // go in grocerries categegories databse and get the categories of particular user
        let groceries = try await GroceryCategory.query(on: req.db).filter(\.$user.$id == userId)
            .all()
            .compactMap { try GroceryCategoryResponseDTO(id: $0.requireID(), title: $0.title, colorCode: $0.colorCode)}
        
        // return the json
        
        return groceries
    }
}
