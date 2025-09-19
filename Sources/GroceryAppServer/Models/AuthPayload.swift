//
//  AuthPayload.swift
//  GroceryAppServer
//
//  Created by sangam pokharel on 19/09/2025.
//

import Foundation
import JWT

struct AuthPayload:JWTPayload {
   
    typealias Payload = AuthPayload
    
    enum CodingKeys:String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case userId = "uid"
    }
    var subject:SubjectClaim
    var expiration:ExpirationClaim
    var userId:UUID
    
    func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        try self.expiration.verifyNotExpired()
    }
    
    
}
