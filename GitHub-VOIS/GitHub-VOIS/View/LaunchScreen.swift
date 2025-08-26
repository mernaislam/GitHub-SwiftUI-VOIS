//
//  LaunchScreen.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 26/08/2025.
//

import SwiftUI

struct LaunchScreen: View {
    @Binding var isActive: Bool
    @State var fadeOut = false
    var body: some View {
        ZStack {
            Color(.black)
                .scaledToFill()
                .ignoresSafeArea()
            
            Image("transparent_github_logo")
                .resizable()
                .frame(width: 300, height: 200)
                .opacity(fadeOut ? 0 : 1)
                
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    fadeOut = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isActive = false
                    }
                }
            }
        }
    }
}

#Preview {
    LaunchScreen(isActive: .constant(true))
}
