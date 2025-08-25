//
//  UserDetailsView.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 23/08/2025.
//

import SwiftUI

struct UserDetailsView: View {
    @StateObject private var viewModel: UserDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(username: String) {
        _viewModel = StateObject(wrappedValue: UserDetailsViewModel(username: username))
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    HStack (spacing: 20){
                        AsyncImage(url: URL(string: viewModel.user?.profile ?? "")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(25)
                            case .failure:
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .foregroundStyle(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        VStack(alignment: .leading){
                            Text(viewModel.user?.name ?? "")
                                .foregroundStyle(.white)
                                .font(.title)
                            Text(viewModel.user?.username ?? "")
                                .foregroundStyle(.white.opacity(0.5))
                                .font(.title3)
                        }
                    }
                    if viewModel.user?.bio != nil {
                        Text((viewModel.user?.bio)!)
                            .foregroundStyle(.white)
                            .font(.title3)
                    }
                    if viewModel.user?.company != nil && viewModel.user?.location != nil {
                        HStack{
                            if viewModel.user?.company != nil {
                                Image(systemName: "building.2")
                                Text((viewModel.user?.company)!)
                                    .padding(.trailing, 10)
                            }
                            if viewModel.user?.location != nil {
                                Image(systemName: "house")
                                Text((viewModel.user?.location)!)
                            }
                        }
                        .foregroundStyle(.white.opacity(0.6))
                    }
                    HStack {
                        Image(systemName: "person.2")
                            .foregroundStyle(.white.opacity(0.6))
                        Text("\(viewModel.user?.followers ?? 0)")
                            .foregroundStyle(.white)
                        Text("followers . ")
                            .foregroundStyle(.white.opacity(0.6))
                        Text("\(viewModel.user?.following ?? 0)")
                            .foregroundStyle(.white)
                        Text("following")
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    Color(.white)
                        .frame(height: 1)
                    HStack {
                        Text("Repository")
                            .foregroundStyle(.white)
                            .font(.title)
                        Spacer()
                        Text("\(viewModel.user?.publicRepos ?? 0)")
                            .foregroundStyle(.white)
                            .font(.title3)
                    }
                    if let repos = viewModel.userRepos {
                        if repos.isEmpty {
                            Text("No repositories available")
                                .foregroundStyle(.white.opacity(0.6))
                                .padding(.top, 10)
                        } else {
                            ScrollView {
                                LazyVStack(alignment: .leading, spacing: 15) {
                                    ForEach(repos, id: \.name) { repo in
                                        VStack(alignment: .leading, spacing: 8) {
                                            // Repo name
                                            Text(repo.name)
                                                .font(.headline)
                                                .foregroundStyle(.white)
                                            
                                            // Repo description
                                            if let description = repo.description {
                                                Text(description)
                                                    .font(.subheadline)
                                                    .foregroundStyle(.white.opacity(0.8))
                                            }
                                            
                                            HStack(spacing: 15) {
                                                // Repo language
                                                if let language = repo.language {
                                                    HStack(spacing: 4) {
                                                        Circle()
                                                            .frame(width: 8, height: 8)
                                                            .foregroundStyle(.blue)
                                                        Text(language)
                                                            .font(.caption)
                                                            .foregroundStyle(.white.opacity(0.7))
                                                    }
                                                }
                                                
                                                // Repo visibility
                                                Text(repo.isPrivate ? "Private" : "Public")
                                                    .font(.caption)
                                                    .foregroundStyle(repo.isPrivate ? .red : .green)
                                                
                                                Spacer()
                                                
                                                // Last updated
                                                Text("Updated: \(repo.updatedAt.prefix(10))")
                                                    .font(.caption)
                                                    .foregroundStyle(.white.opacity(0.6))
                                            }
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                    }
                                }
                                .padding(.top, 10)
                            }
                        }
                    } else {
                        ProgressView("Loading Repositories...")
                            .foregroundStyle(.white)
                            .padding(.top, 10)
                    }
                   
                }
                .padding()
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .withStaticBackground()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                }
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
        
    }
}
