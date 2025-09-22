//
//  GroceryItemResponseDTO.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 22/09/2025.
//

import Foundation
import Vapor

struct GroceryItemResponseDTO:Content {
    var id:UUID
    var title:String
    var price:Double
    var quantity:Int
    
    init(id:UUID,title: String, price: Double, quantity: Int) {
        self.id = id
        self.title = title
        self.price = price
        self.quantity = quantity
    }
}
