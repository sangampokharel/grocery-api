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
        
        // /api/users/:userId [Protected Route]
        let api = routes.grouped("api","users",":userId").grouped(JSONWebTokenAuthenticator())
        
        //POST: Saving GroceryCategory
        // /api/users/:userId/grocery-categories
        api.post("grocery-categories", use: saveGroceryCategories)
        
        //GET: TO get the list of categories of particular users
        api.get("grocery-categories",use:getGroceryCategoriesByUser)
        
        //Delete: Delete grocery
        // /api/users/:userId/grocery-categories/:groceryId
        api.delete("grocery-categories", ":groceryCategoryId", use: deleteGroceryCategory)
        
        // /api/users/:userId/grocery-categories/:groceryCategoryId/grocery-items
        //POST: Create Grocery Item
        api.post("grocery-categories", ":groceryCategoryId" ,"grocery-items", use: postGroceryItem)
        
        // get partcular categories items
        //GET: /users/:userId/grocery-categories/:groceryCategoryId/grocery-items
        api.get("grocery-categories",":groceryCategoryId","grocery-items",use:getGroceryCategoriesItems)
        
        // delete groceryItems
        //GET: /users/:userId/grocery-categories/:groceryCategoryId/grocery-items/:groceryItemId
        api.delete("grocery-categories",":groceryCategoryId","grocery-items",":groceryItemId",use:deleteGroceryItem)
        
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
    
    func postGroceryItem(req:Request) async throws -> GroceryItemResponseDTO {
        // validate the req
        try GroceryItemRequestDTO.validate(content:req)
        
        // decode the params
        guard let userId = req.parameters.get("userId",as:UUID.self),
              let groceryCategoryId = req.parameters.get("groceryCategoryId",as:UUID.self) else {
            throw Abort(.notFound)
        }
        
        // find the user
        guard let _ = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound)
        }
        
        // find the grocery category
        guard let grocery = try await GroceryCategory.query(on: req.db)
            .filter(\.$user.$id == userId)
            .filter(\.$id == groceryCategoryId)
            .first() else {
            throw Abort(.notFound)
        }
        
        // decode the body
        let groceryItemRequestDto = try req.content.decode(GroceryItemRequestDTO.self)
        let grocertItem = GroceryItem(title: groceryItemRequestDto.title, price: groceryItemRequestDto.price, quantity: groceryItemRequestDto.quantity, groceryCategory: try grocery.requireID())
        
        // save
        try await grocertItem.save(on: req.db)
        return GroceryItemResponseDTO(id: try grocertItem.requireID(), title: grocertItem.title, price: grocertItem.price, quantity: grocertItem.quantity)
    }
    
    func getGroceryCategoriesItems(req:Request) async throws -> [GroceryItemResponseDTO] {
        guard let userId = req.parameters.get("userId",as:UUID.self),
              let groceryCategoryId = req.parameters.get("groceryCategoryId",as:UUID.self) else {
            throw Abort(.notFound)
        }
        
        guard let _ = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let groceryItems = try await GroceryItem.query(on: req.db)
            .filter(\.$groceryCategory.$id == groceryCategoryId)
            .all()
            .compactMap { GroceryItemResponseDTO(id: try $0.requireID(), title: $0.title, price: $0.price, quantity: $0.quantity)}
        
        return groceryItems
    }
    
    func deleteGroceryItem(req:Request) async throws -> GroceryItemResponseDTO {
        
        // check all three ids
        guard let userId = req.parameters.get("userId",as: UUID.self),
              let groceryCategoryId = req.parameters.get("groceryCategoryId",as: UUID.self),
              let groceryCategoryItemId = req.parameters.get("groceryItemId",as: UUID.self) else {
            throw Abort(.notFound)
        }
        guard let _ = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard let _ = try await GroceryCategory.query(on: req.db)
            .filter(\.$user.$id == userId)
            .filter(\.$id == groceryCategoryId)
            .first() else {
            
            throw Abort(.notFound)
        }
        
        guard let grocery = try await GroceryItem.query(on: req.db)
            .filter(\.$groceryCategory.$id == groceryCategoryId)
            .filter(\.$id == groceryCategoryItemId)
            .first() else {
            throw Abort(.notFound)
        }
        try await grocery.delete(on: req.db)
        return GroceryItemResponseDTO(id: try grocery.requireID(), title: grocery.title, price: grocery.price, quantity: grocery.quantity)
    }
    
    
}
