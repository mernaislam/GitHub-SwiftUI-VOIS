//
//  ContentView.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 22/08/2025.
//

import SwiftUI

struct SearchView: View {
    @State var searchText: String
    @State var users: UserList?
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(users: users)
                ForegroundView(searchText: $searchText, users: $users)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    SearchView(searchText: "name")
}

struct ForegroundView: View {
    @Binding var searchText: String
    @StateObject var viewModel = SearchViewModel()
    @Binding var users: UserList?

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white.opacity(0.5))
                
                TextField(Constants.Texts.searchPlaceholder, text: $searchText)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.go)
                    .onSubmit {
                        viewModel.searchUsers(username: searchText) { response in
                            switch response {
                                case .success(let users):
                                    DispatchQueue.main.async {
                                        self.users = users
                                    }
                                case .failure(let error):
                                    print(error)
                            }
                        }
                    }
                
                if !searchText.isEmpty {
                    Button(action: { 
                        searchText = ""
                        users = nil
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
            .padding()
            .background(Color("primary").opacity(0.5))
            .cornerRadius(20)
            .padding(.horizontal, 20)
            
            if let users = users?.users {
                SearchResults(users: users)
            } else {
                VStack {
                    Spacer()
                    Text(Constants.Texts.title)
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal, 20)
                    
                    Text(Constants.Texts.subtitle)
                        .foregroundStyle(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 60)
                    Spacer()
                }
            }
            
            
            
        }
        .padding(.top, 80)
    }
}

struct BackgroundView: View {
    var users: UserList?
    @State private var isRotating = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()
                
                Image("bg-addon5")
                    .resizable()
                    .scaledToFit()
                    .offset(y: geo.size.height * 0.4)
                
                Image("bg-addon5")
                    .resizable()
                    .scaledToFit()
                    .offset(y: geo.size.height * 0)
                
                if users == nil {
                    Image("bg-addon1")
                        .resizable()
                        .frame(width: 150, height: 350)
                        .offset(
                            x: -(geo.size.width * 0.3),
                            y: -(geo.size.height * 0.22)
                        )
                    
                    Image("bg-addon2")
                        .resizable()
                        .frame(width: 150, height: 108)
                        .offset(
                            x: (geo.size.width * 0.2),
                            y: -(geo.size.height * 0.2)
                        )
                    
                    
                    Image("bg-addon3")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .rotationEffect(.degrees(isRotating ? 360 : 0))
                        .animation(
                            .linear(duration: 20).repeatForever(autoreverses: false),
                            value: isRotating
                        )
                        .offset(y: geo.size.height * 0.3)
                        .onAppear {
                            isRotating = true
                        }
                        
                    
                    Image("bg-addon4")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .offset(y: geo.size.height * 0.4)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
    }
}
