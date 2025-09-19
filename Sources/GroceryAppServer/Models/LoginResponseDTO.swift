//
//  LoginResponseDTO.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 19/09/2025.
//

import Foundation
import Vapor

struct LoginResponseDTO:Content {
    
    let error:Bool
    var reason:String?
    let token:String?
    let userId:UUID
    
}
