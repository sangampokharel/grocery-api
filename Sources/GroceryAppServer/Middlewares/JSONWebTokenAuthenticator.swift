//
//  JSONWebTokenAuthenticator.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 22/09/2025.
//

import Foundation
import Vapor
struct JSONWebTokenAuthenticator:AsyncRequestAuthenticator {
  
    func authenticate(request: Vapor.Request) async throws {
        try await request.jwt.verify(as: AuthPayload.self)
    }
    
    
    
}
