//
//  GameOverScreen.swift
//  TriadChordGame
//
//  Created by Dhil Khairan Badjiser on 26/05/23.
//

import SwiftUI

struct GameOverScreen: View {
    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .blur(radius: 3)
                
                
                ZStack {
                    Rectangle()
                        .fill(Color.brown)
                    
                        .frame(width: 300, height: 290)
                        .cornerRadius(20)
                    
                    VStack {
                        
                        Button(action: {
                            // Handle button action here
                            
                        }) {
                            NavigationLink(
                                destination: ContentView(),
                                label: {
                                    Text("Retry")
                                        .font(Font.custom("Minecraft", size: 45))
                                        .foregroundColor(.white)
                                        .padding(.bottom,60)
                                })
                        }
                        
                        Button(action: {
                            // Handle button action here
                            
                        }) {
                            NavigationLink(
                                destination: StartScreenView(),
                                label: {
                                    Text("Exit")
                                        .font(Font.custom("Minecraft", size: 45))
                                        .foregroundColor(.white)
                                        .padding(.bottom,60)
                                })
                        }
                    }
                }
                
                
                
            }
        }
    }
}

struct GameOverScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameOverScreen()
    }
}
