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
        
        // /api/login
        api.post("login", use: login)
    }
    
    func login(req:Request) async throws -> LoginResponseDTO {
        
        // validate
        try User.validate(content: req)
        
        // decode the request
        let user = try req.content.decode(User.self)
        
        //check if the user
        guard let exisitingUser = try await User.query(on: req.db)
            .filter(\.$username == user.username)
            .first() else {
            throw Abort(.notFound)
        }
        
        
        // validate password
        let result = try await req.password.async.verify(user.password, created: exisitingUser.password)
        
        if !result {
            throw Abort(.unauthorized)
        }
        
        // generate the token and return it to user
        let authPayload = try AuthPayload(subject: .init(value: "Grocery App"), expiration: .init(value: .distantFuture), userId: exisitingUser.requireID())
        
        return try await LoginResponseDTO(error: false, token: req.jwt.sign(authPayload), userId: exisitingUser.requireID())
    }
    
    @Sendable func register(req:Request) async throws -> RegisterResponseDTO {
        
        // validate the user
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
