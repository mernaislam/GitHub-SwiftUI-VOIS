//
//  View+Background.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 23/08/2025.
//

import Foundation
import SwiftUI

extension View {
    func withStaticBackground() -> some View {
        self.background(
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
                        .rotationEffect(.degrees(180))
                }
            }

        )
    }
}
