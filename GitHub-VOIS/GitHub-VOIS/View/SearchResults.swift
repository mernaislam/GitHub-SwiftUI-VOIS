//
//  SearchItem.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 22/08/2025.
//

import SwiftUI

struct SearchResults: View {
    var users: [User]
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading){
                ForEach(users, id: \.id) { user in
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
                                Image(systemName: "person.crop.circle.fill") // fallback image
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
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color("primary").opacity(0.35))
                    .cornerRadius(20)
                    .padding(.top, 5)
                }
                
            }
            .padding()
            Spacer()
        }
        
    }
}
