//
//  UserRepo.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 25/08/2025.
//

import Foundation

struct UserRepo: Codable {
    let name: String
    let isPrivate: Bool
    let description: String?
    let language: String?
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case isPrivate = "private"
        case description
        case language
        case updatedAt = "updated_at"
    }
}
