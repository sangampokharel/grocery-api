//
//  UserController.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 17/09/2025.
//

import Vapor
import Fluent

// api/register
// api/login

class UserController: RouteCollection, @unchecked Sendable {
   
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let api = routes.grouped("api")
        
        // /api/register
        api.post("register", use: register)
    }
    
    @Sendable func register(req:Request) async throws -> RegisterResponseDTO {
        // validate the user // validations
        
        try User.validate(content: req)
        
        let user = try req.content.decode(User.self)
        
        // find if the user already exists using the username
        if let _ = try await User.query(on: req.db)
            .filter(\.$username == user.username)
            .first(){
            throw Abort(.conflict, reason: "Username is already taken")
        }
        
        // hash the passowrd
        
        user.password = try await req.password.async.hash(user.password)
        
        try await user.save(on: req.db)
        
        return RegisterResponseDTO(error: false)
        
    }
    
    
}
