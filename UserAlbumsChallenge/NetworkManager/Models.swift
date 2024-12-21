//
//  Models.swift
//  UserAlbumsChallenge
//
//  Created by mac on 20/12/2024.
//

import Foundation

struct UserProfile: Decodable {
    let id: Int
    let name: String
    let address: Address
}

struct Address: Decodable {
    let street: String
    let city: String
}

struct Album: Decodable {
    let id: Int
    let userId: Int
    let title: String
}

struct Photo: Decodable {
    let id: Int
    let albumId: Int
    let title: String
    let url: String
    
    func toURL() -> URL {
        guard let validURL = URL(string: self.url) else {
            fatalError("Invalid URL: \(self.url)")
        }
        return validURL
    }
}
