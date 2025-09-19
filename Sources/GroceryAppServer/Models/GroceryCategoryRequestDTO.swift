//
//  GroceryCategoryRequestDTO.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 19/09/2025.
//

import Foundation
import Vapor

struct GroceryCategoryRequestDTO: Content, Validatable {
    let title: String
    let colorCode: String
    
    init(title: String, colorCode: String) {
        self.title = title
        self.colorCode = colorCode
    }
    
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty, customFailureDescription: "Category Title is required")
        validations.add("colorCode", as: String.self, is: !.empty, customFailureDescription: "Color Code is required")
    }
}