//
//  UserDetailsView.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 23/08/2025.
//

import SwiftUI
import SafariServices
import UIKit

// MARK: User Details View
struct UserDetailsView: View {
    @StateObject private var viewModel: UserDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedURL: URL? = nil
    @State private var sortOption: RepoSortOption = .updatedDesc
    
    init(username: String) {
        _viewModel = StateObject(wrappedValue: UserDetailsViewModel(username: username))
    }
    
    // MARK: - Sorting
    private enum RepoSortOption: String, CaseIterable, Identifiable {
        case updatedDesc = "Updated"
        case nameAsc = "Name"
        var id: String { rawValue }
    }
    
    private var sortedRepos: [UserRepo]? {
        guard let repos = viewModel.userRepos else { return nil }
        switch sortOption {
        case .updatedDesc:
            let formatter = ISO8601DateFormatter()
            return repos.sorted { lhs, rhs in
                let l = formatter.date(from: lhs.updatedAt) ?? .distantPast
                let r = formatter.date(from: rhs.updatedAt) ?? .distantPast
                return l > r
            }
        case .nameAsc:
            return repos.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
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
                    sortControl
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
        .sheet(isPresented: Binding<Bool>(
            get: { selectedURL != nil },
            set: { if !$0 { selectedURL = nil } }
        )) {
            if let url = selectedURL {
                SafariView(url: url)
                    .ignoresSafeArea()
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
        HStack(spacing: 6) {
            Image(systemName: "person.2")
                .foregroundStyle(.white.opacity(0.6))
            Button {
                if let username = viewModel.user?.username,
                   let url = URL(string: "https://github.com/\(username)?tab=followers") {
                    selectedURL = url
                }
            } label: {
                HStack(spacing: 4) {
                    Text("\(viewModel.user?.followers ?? 0)")
                        .foregroundStyle(.white)
                    Text("followers")
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            .buttonStyle(.plain)
            Text("·")
                .foregroundStyle(.white.opacity(0.6))
            Button {
                if let username = viewModel.user?.username,
                   let url = URL(string: "https://github.com/\(username)?tab=following") {
                    selectedURL = url
                }
            } label: {
                HStack(spacing: 4) {
                    Text("\(viewModel.user?.following ?? 0)")
                        .foregroundStyle(.white)
                    Text("following")
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    private var divider: some View {
        Color(.white)
            .frame(height: 1)
    }
    
    private var reposHeader: some View {
        HStack {
            Text("Repositories")
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
            if let repos = sortedRepos {
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

    private var sortControl: some View {
        Picker("Sort", selection: $sortOption) {
            ForEach(RepoSortOption.allCases) { option in
                Text(option.rawValue).tag(option)
            }
        }
        .pickerStyle(.segmented)
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
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if let username = viewModel.user?.username,
               let url = URL(string: "https://github.com/\(username)/\(repo.name)") {
                selectedURL = url
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
    @State private var isShowingSafari: Bool = false

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
            Spacer()
            Button(action: { isShowingSafari = true }) {
                Image(systemName: "arrow.up.forward.app")
                    .foregroundStyle(.white)
                    .font(.title)
            }
            .disabled(githubURL == nil)
        }
        .sheet(isPresented: $isShowingSafari) {
            if let url = githubURL {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
        .contextMenu {
            if let url = githubURL {
                ShareLink(item: url) {
                    Label("Share Profile", systemImage: "square.and.arrow.up")
                }
                Button {
                    UIPasteboard.general.url = url
                } label: {
                    Label("Copy Profile URL", systemImage: "doc.on.doc")
                }
                Button {
                    let scheme = "github://user?login=\(user?.username ?? "")"
                    if let appURL = URL(string: scheme), UIApplication.shared.canOpenURL(appURL) {
                        UIApplication.shared.open(appURL)
                    } else {
                        if let webURL = githubURL {
                            UIApplication.shared.open(webURL)
                        }
                    }
                } label: {
                    Label("Open in GitHub App", systemImage: "app")
                }
            }
        }
    }

    private var githubURL: URL? {
        guard let username = user?.username else { return nil }
        return URL(string: "https://github.com/\(username)")
    }
}

// MARK: Safari Wrapper
private struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        controller.preferredBarTintColor = .black
        controller.preferredControlTintColor = .white
        return controller
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // no-op
    }
}

