//
//  UserDetailsViewModel.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 24/08/2025.
//

import Foundation

final class UserDetailsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var user: UserDetails?
    @Published var userRepos: [UserRepo]?
    @Published var errorMessage: String? = nil

    // MARK: - Private State
    private let username: String
    private let genericErrorMessage = "Something went wrong. Please try again."

    // MARK: - Init
    init(username: String) {
        self.username = username
        loadUserDetails()
        loadUserRepos()
    }

    // MARK: - Public API
    func loadUserDetails() {
        let urlString = "https://api.github.com/users/\(username)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }

            switch self.validateResponse(data: data, response: response, error: error) {
            case .failure:
                DispatchQueue.main.async {
                    self.errorMessage = self.genericErrorMessage
                    self.user = nil
                }
            case .success(let data):
                do {
                    let userDetails = try JSONDecoder().decode(UserDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.user = userDetails
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = self.genericErrorMessage
                    }
                }
            }
        }.resume()
    }

    func loadUserRepos() {
        let urlString = "https://api.github.com/users/\(username)/repos"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }

            switch self.validateResponse(data: data, response: response, error: error) {
            case .failure:
                DispatchQueue.main.async {
                    self.errorMessage = self.genericErrorMessage
                    self.userRepos = nil
                }
            case .success(let data):
                do {
                    let userRepos = try JSONDecoder().decode([UserRepo].self, from: data)
                    DispatchQueue.main.async {
                        self.userRepos = userRepos
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = self.genericErrorMessage
                    }
                }
            }
        }.resume()
    }

    // MARK: - Helpers
    private func validateResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, Error> {
        if error != nil {
            return .failure(DataError.invalidData)
        }
        guard let data else {
            return .failure(DataError.invalidData)
        }
        guard let httpResponse = response as? HTTPURLResponse, 200 ... 299 ~= httpResponse.statusCode else {
            return .failure(DataError.invalidResponse)
        }
        return .success(data)
    }
}
