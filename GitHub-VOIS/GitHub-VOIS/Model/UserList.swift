//
//  UserList.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 22/08/2025.
//

import Foundation

struct UserList: Codable {
    let users: [User]
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case users = "items"
        case totalCount = "total_count"
    }
}
