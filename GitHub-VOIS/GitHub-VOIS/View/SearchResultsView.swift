//
//  SearchItem.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 22/08/2025.
//

import SwiftUI

// MARK: - SearchResultsView
struct SearchResultsView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        Group {
            if let users = viewModel.users?.users, !users.isEmpty {
                resultsList(users: users)
            } else {
                emptyState
            }
        }
    }

    // MARK: - Sections
    private func resultsList(users: [User]) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading){
                ForEach(users, id: \.id) { user in
                    NavigationLink(destination: UserDetailsView(username: user.username)) {
                        SearchResultRow(user: user)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onAppear {
                        if viewModel.reachedLastUser(of: user) {
                            viewModel.fetchNextUsers()
                        }
                    }
                }
            }
            .padding()
            Spacer()
        }
    }
    
    private var emptyState: some View {
        VStack {
            Text("No users found")
                .foregroundStyle(.white.opacity(0.7))
                .padding()
            Spacer()
        }
    }
}

// MARK: - Row
private struct SearchResultRow: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 10) {
            avatar
            info
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color("primary").opacity(0.35))
        .cornerRadius(20)
        .padding(.top, 5)
    }
    
    // MARK: - Components
    /// Profile photo of the user
    private var avatar: some View {
        AsyncImage(url: URL(string: user.photo)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
            case .failure:
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.gray)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    /// Info for each user (username, id)
    private var info: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(user.username)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .font(.title3)
            
            Text("#\(user.id)")
                .foregroundStyle(.white.opacity(0.5))
                .font(.subheadline)
        }
    }
}
