//
//  GroceryItemRequestDTO.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 22/09/2025.
//

import Foundation
import Vapor

struct GroceryItemRequestDTO:Content, Validatable {
 
    var title:String
    var price:Double
    var quantity:Int
    
    init(title: String, price: Double, quantity: Int) {
        self.title = title
        self.price = price
        self.quantity = quantity
    }
    
    static func validations(_ validations: inout Vapor.Validations) {
        validations.add("title",as:String.self,is:!.empty,required: true,customFailureDescription: "Title is required")
        validations.add("price", as: Double.self, is: .range(1...), required: true, customFailureDescription: "Price must be greater than 1") // Positive price
        validations.add("quantity", as: Int.self, is: .range(1...), required: true, customFailureDescription: "Quantity must be at least 1") // Positive quantity
    
    }
}
