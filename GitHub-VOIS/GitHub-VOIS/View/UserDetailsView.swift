//
//  UserDetailsView.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 23/08/2025.
//

import SwiftUI

// MARK: User Details View
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
                    header
                    bioSection
                    companyLocationSection
                    followersSection
                    divider
                    reposHeader
                    reposSection
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
    
    // MARK: - Sections
    private var header: some View {
        UserDetailsRow(user: viewModel.user)
    }
    
    private var bioSection: some View {
        Group {
            if let bio = viewModel.user?.bio, !bio.isEmpty {
                Text(bio)
                    .foregroundStyle(.white)
                    .font(.title3)
            }
        }
    }
    
    private var companyLocationSection: some View {
        Group {
            if viewModel.user?.company != nil || viewModel.user?.location != nil {
                HStack {
                    if let company = viewModel.user?.company, !company.isEmpty {
                        Image(systemName: "building.2")
                        Text(company)
                            .padding(.trailing, 10)
                    }
                    if let location = viewModel.user?.location, !location.isEmpty {
                        Image(systemName: "house")
                        Text(location)
                    }
                }
                .foregroundStyle(.white.opacity(0.6))
            }
        }
    }
    
    private var followersSection: some View {
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
    }
    
    private var divider: some View {
        Color(.white)
            .frame(height: 1)
    }
    
    private var reposHeader: some View {
        HStack {
            Text("Repository")
                .foregroundStyle(.white)
                .font(.title)
            Spacer()
            Text("\(viewModel.user?.publicRepos ?? 0)")
                .foregroundStyle(.white)
                .font(.title3)
        }
    }
    
    private var reposSection: some View {
        Group {
            if let repos = viewModel.userRepos {
                if repos.isEmpty {
                    Text("No repositories available")
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.top, 10)
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 15) {
                            ForEach(repos, id: \.name) { repo in
                                repoCard(repo)
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
    }
    
    // MARK: - Components
    private func repoCard(_ repo: UserRepo) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(repo.name)
                .font(.headline)
                .foregroundStyle(.white)
            
            if let description = repo.description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            HStack(spacing: 15) {
                if let language = repo.language, !language.isEmpty {
                    HStack(spacing: 4) {
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(.blue)
                        Text(language)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                
                Text(repo.isPrivate ? "Private" : "Public")
                    .font(.caption)
                    .foregroundStyle(repo.isPrivate ? .red : .green)
                
                Spacer()
                
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

// MARK: User Details Row
private struct UserDetailsRow: View {
    let user: UserDetails?

    var body: some View {
        HStack (spacing: 20){
            AsyncImage(url: URL(string: user?.profile ?? "")) { phase in
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
                Text(user?.name ?? "")
                    .foregroundStyle(.white)
                    .font(.title)
                Text(user?.username ?? "")
                    .foregroundStyle(.white.opacity(0.5))
                    .font(.title3)
            }
        }
    }
}

