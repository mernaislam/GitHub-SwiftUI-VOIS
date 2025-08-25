//
//  SearchViewModel.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 22/08/2025.
//

import Foundation

final class SearchViewModel: ObservableObject {
    @Published var users: UserList?
    @Published var errorMessage: String? = nil
    private var currentPage = 1
    private var currentQuery = ""
    private var isLoading = false
    
    private func searchUsers(username: String, page: Int, completion: @escaping (Result<UserList, Error>) -> Void) {
        let urlString = "https://api.github.com/search/users?q=\(username)&page=\(page)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(.failure(DataError.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
                completion(.failure(DataError.invalidResponse))
                return
            }
            
            do {
                let userList = try JSONDecoder().decode(UserList.self, from: data)
                completion(.success(userList))
            } catch {
                completion(.failure(DataError.message(error)))
            }
        }.resume()
    }

    func fetchUsers(username: String, page: Int = 1, completion: (() -> Void)? = nil) {
        guard !isLoading else { return }
        isLoading = true
        currentQuery = username
        
        self.searchUsers(username: username, page: page) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newUsers):
                    if page == 1 {
                        self?.users = newUsers
                    } else {
                        self?.users?.users.append(contentsOf: newUsers.users)
                    }
                    self?.currentPage = page
                case .failure:
                    self?.errorMessage = "Something went wrong. Please try again."
                }
                self?.isLoading = false
                completion?()
            }
        }
    }
    
    // Fetch next page
    func fetchNextUsers(completion: (() -> Void)? = nil) {
        fetchUsers(username: currentQuery, page: currentPage + 1, completion: completion)
    }
    
    // Helper to know if we're at the last user
    func reachedLastUser(of user: User) -> Bool {
        user.id == users?.users.last?.id
    }
}
