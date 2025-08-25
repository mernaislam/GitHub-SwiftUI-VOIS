//
//  UserDetailsViewModel.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 24/08/2025.
//

import Foundation
final class UserDetailsViewModel: ObservableObject {
    @Published var user: UserDetails?
    @Published var userRepos: [UserRepo]?
    @Published var errorMessage: String? = nil
    private var username: String
    
    init(username: String) {
        self.username = username
        loadUserDetails()
        loadUserRepos()
    }
    
    func loadUserDetails() {
        let urlString = "https://api.github.com/users/\(username)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                DispatchQueue.main.async {
                    self.user = nil
                }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async {
                    self.errorMessage = "Something went wrong. Please try again."
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                DispatchQueue.main.async {
                    self.errorMessage = "Something went wrong. Please try again."
                }
                return
            }
            
            do {
                let userDetails = try JSONDecoder().decode(UserDetails.self, from: data)
                DispatchQueue.main.async {
                    self.user = userDetails
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Something went wrong. Please try again."
                }
            }
        }.resume()
    }
    
    func loadUserRepos() {
        let urlString = "https://api.github.com/users/\(username)/repos"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                DispatchQueue.main.async {
                    self.user = nil
                }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async {
                    self.errorMessage = "Something went wrong. Please try again."
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                DispatchQueue.main.async {
                    self.errorMessage = "Something went wrong. Please try again."
                }
                return
            }
            
            do {
                let userRepos = try JSONDecoder().decode([UserRepo].self, from: data)
                DispatchQueue.main.async {
                    self.userRepos = userRepos
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Something went wrong. Please try again."
                }
            }
        }.resume()
    }
}
