//
//  ContentView.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 22/08/2025.
//

import SwiftUI

struct SearchView: View {
    @State var searchText: String
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(viewModel: viewModel)
                ForegroundView(searchText: $searchText, viewModel: viewModel)
            }
            .ignoresSafeArea()
        }
    }
}

struct ForegroundView: View {
    @Binding var searchText: String
    @ObservedObject var viewModel: SearchViewModel

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
                        viewModel.fetchUsers(username: searchText)
                    }
                
                if !searchText.isEmpty {
                    Button(action: { 
                        searchText = ""
                        viewModel.users = nil
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
            
            if (viewModel.users?.users) != nil {
                SearchResultsView(viewModel: viewModel)
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

struct BackgroundView: View {
    @ObservedObject var viewModel: SearchViewModel
    @State private var isRotating = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("bg-addon1")
                    .resizable()
                    .frame(width: 150, height: 350)
                    .offset(
                        x: -(geo.size.width * 0.3),
                        y: -(geo.size.height * 0.22)
                    )
                    .opacity(viewModel.users == nil ? 1 : 0)
                
                Image("bg-addon2")
                    .resizable()
                    .frame(width: 150, height: 108)
                    .offset(
                        x: (geo.size.width * 0.2),
                        y: -(geo.size.height * 0.2)
                    )
                    .opacity(viewModel.users == nil ? 1 : 0)
                
                
                Image("bg-addon3")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .rotationEffect(.degrees(isRotating ? 360 : 0))
                    .animation(
                        .linear(duration: 20).repeatForever(autoreverses: false),
                        value: isRotating
                    )
                    .offset(y: geo.size.height * 0.3)
                    .opacity(viewModel.users == nil ? 1 : 0)
                    .onAppear {
                        isRotating = true
                    }
                    
                
                Image("bg-addon4")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .offset(y: geo.size.height * 0.4)
                    .opacity(viewModel.users == nil ? 1 : 0)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
            .withStaticBackground()
        }
    }
}
