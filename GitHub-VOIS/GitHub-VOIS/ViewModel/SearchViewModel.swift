//
//  SearchViewModel.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 22/08/2025.
//

import Foundation

final class SearchViewModel: ObservableObject {
    
    func searchUsers(username: String, completion: @escaping (Result<UserList, Error>) -> Void){
        let url = URL(string: "https://api.github.com/search/users?q=\(username)")

        URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data else {
                completion(.failure(DataError.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
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
}
