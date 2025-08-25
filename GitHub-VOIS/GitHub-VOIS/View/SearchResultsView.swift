//
//  SearchItem.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 22/08/2025.
//

import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        if let users = viewModel.users?.users, !users.isEmpty {
            ScrollView {
                LazyVStack(alignment: .leading){
                    ForEach(users, id: \.id) { user in
                        NavigationLink(destination: UserDetailsView(username: user.username)) {
                            HStack(spacing: 10) {
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
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(user.username)
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                        .font(.title3)
                                    
                                    Text("#\(user.id)")
                                        .foregroundStyle(.white.opacity(0.5))
                                        .font(.subheadline)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.white)
                                
                            }
                            .task {
                                
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color("primary").opacity(0.35))
                            .cornerRadius(20)
                            .padding(.top, 5)
                            .onAppear {
                                if viewModel.reachedLastUser(of: user) {
                                    viewModel.fetchNextUsers()
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())

                    }
                }
                .padding()
                Spacer()
            }
            
        } else {
            VStack {
                Text("No users found")
                    .foregroundStyle(.white.opacity(0.7))
                    .padding()
                Spacer()
            }
           
        }
        
    }
}
