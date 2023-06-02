//
//  ContentView.swift
//  TriadChordGame
//
//  Created by Dhil Khairan Badjiser on 18/05/23.
//
//Final

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    var scene = SKScene(fileNamed: "Level_1_Scene")!
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
