//
//  StartScreen.swift
//  TriadChordGame
//
//  Created by Dhil Khairan Badjiser on 25/05/23.
//


import SwiftUI

struct StartScreenView: View {
    
    @State private var isActive: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack {
                    Text("TRIAD MASTER")
                        .font(Font.custom("Minecraft", size: 60))
                        .foregroundColor(.white)
                        .padding(.top, 100)
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle button action here
                        isActive = true
                    }) {
                        NavigationLink(
                            destination: ContentView(),
                            label: {
                                Text("Start")
                                    .font(Font.custom("Minecraft", size: 45))
                                    .foregroundColor(.white)
                                    .padding(.bottom,60)
                            })
                    }
                }
            }
        }
        
    }
    
    
    
    struct StartScreenView_Previews: PreviewProvider {
        static var previews: some View {
            StartScreenView()
        }
    }
}
