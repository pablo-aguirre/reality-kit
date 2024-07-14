//
//  ContentView.swift
//  RealityKitCourse
//
//  Created by Pablo Aguirre on 14/07/24.
//

import SwiftUI
import RealityKit
import AVFoundation

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let anchor = AnchorEntity(plane: .horizontal)
        
        guard let url = Bundle.main.url(forResource: "video", withExtension: "mp4") else { fatalError("Video not found!") }
        let player = AVPlayer(url: url)
        
        let material = VideoMaterial(avPlayer: player)
        material.controller.audioInputMode = .spatial // for video with audio
        
        let model = ModelEntity(mesh: .generatePlane(width: 0.5, depth: 0.5), materials: [material])
        player.play()
        
        anchor.addChild(model)
        arView.scene.addAnchor(anchor)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
