//
//  UserDetails.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 23/08/2025.
//

import Foundation

struct UserDetails: Codable {
    let username: String
    let location: String?
    let profile: String
    let company: String?
    let name: String?
    let bio: String?
    let id: Int
    let publicRepos: Int
    let followers: Int
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
        case location
        case profile = "avatar_url"
        case company
        case name
        case bio
        case id
        case publicRepos = "public_repos"
        case followers
        case following
    }
}
