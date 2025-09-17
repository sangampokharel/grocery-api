//
//  RegisterResponseDTO.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 17/09/2025.
//

import Vapor

struct RegisterResponseDTO:Content {
    let error:Bool
    var reason:String? = nil
}
