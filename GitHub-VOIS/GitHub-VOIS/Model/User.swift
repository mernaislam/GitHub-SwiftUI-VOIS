//
//  User.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 22/08/2025.
//

import Foundation

struct User: Codable, Identifiable {
    let username: String
    let photo: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
        case photo = "avatar_url"
        case id = "id"
    }
}
