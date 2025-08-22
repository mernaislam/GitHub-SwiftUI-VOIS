//
//  Constants.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 22/08/2025.
//

import Foundation

struct Constants {
    struct Texts {
        static let title = "Let's Build From Here."
        static let subtitle = """
        Harnessed for productivity. Designed for collaboration. \
        Celebrated for built-in security. Welcome to the platform developers love.
        """
        static let searchPlaceholder = "Search..."
    }
}

enum DataError: Error {
    case invalidData
    case invalidResponse
    case message(_ error: Error?)
}
