//
//  GroceryCategoryResponseDTO.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 19/09/2025.
//

import Foundation
import Vapor

struct GroceryCategoryResponseDTO:Content {
    let id:UUID
    let title:String
    let colorCode:String
    
    init(id: UUID, title: String, colorCode: String) {
        self.id = id
        self.title = title
        self.colorCode = colorCode
    }
}
