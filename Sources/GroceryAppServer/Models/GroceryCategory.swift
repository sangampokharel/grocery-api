//
//  GroceryCategory.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 19/09/2025.
//

import Vapor
import Fluent

final class GroceryCategory:Model, @unchecked Sendable, Content, Validatable {
    
    static let schema: String = "grocery_categories"
    
    @ID(key: .id)
    var id:UUID?
    
    @Field(key: "title")
    var title:String
    
    @Field(key: "color_code")
    var colorCode:String
    
    @Parent(key: "user_id")
    var user:User
    
    required init() {}
    
    init(id: UUID? = nil, title: String, colorCode: String, userID: UUID) {
        self.id = id
        self.title = title
        self.colorCode = colorCode
        self.$user.id = userID
    }
    
    static func validations(_ validations: inout Validations) {
        validations.add("title", as:String.self, is:!.empty, customFailureDescription: "Category Title is required")
        validations.add("color_code", as:String.self, is:!.empty, customFailureDescription: "Color Code is required")
    }
    
    
}
