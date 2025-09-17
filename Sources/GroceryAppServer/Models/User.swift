//
//  User.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 17/09/2025.
//

import Fluent
import Vapor

final class User: Model, @unchecked Sendable, Content, Validatable {
   
    static let schema = "users" // table names
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key:"username")
    var username:String
    
    @Field(key:"password")
    var password:String
    
    init() {}
    
    init(id: UUID? = nil, username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
    }
    
    static func validations(_ validations: inout Validations) {
        validations.add("username", as:String.self, is:!.empty, customFailureDescription: "Username cannot be empty")
        validations.add("password", as:String.self, is:!.empty, customFailureDescription: "Password cannot be empty")
        //password must be between 6.. 10 characters long
        validations.add("password", as:String.self, is:.count(6...10)  , customFailureDescription: "Password must be between 6 and 10 characters long.")
    }
    
    
}
