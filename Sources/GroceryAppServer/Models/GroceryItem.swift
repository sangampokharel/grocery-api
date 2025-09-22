//
//  GroceryItem.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 22/09/2025.
//

import Foundation
import Fluent
import Vapor

class GroceryItem:Model, @unchecked Sendable {
    
    static let schema: String = "grocery_items"
   
    @ID(key: .id)
    var id:UUID?
    
    @Field(key: "title")
    var title:String
    
    @Field(key: "price")
    var price:Double
    
    @Field(key: "quantity")
    var quantity:Int
    
    @Parent(key: "grocery_category_id")
    var groceryCategory:GroceryCategory
    
    required init() {}
    
    init(id: UUID? = nil, title: String, price: Double, quantity: Int, groceryCategory: UUID) {
        self.id = id
        self.title = title
        self.price = price
        self.quantity = quantity
        self.$groceryCategory.id = groceryCategory
    }
    
}
