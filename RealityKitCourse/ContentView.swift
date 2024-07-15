//
//  ContentView.swift
//  RealityKitCourse
//
//  Created by Pablo Aguirre on 14/07/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        
        let floorAnchor = AnchorEntity(plane: .horizontal)
        let floorModel = ModelEntity(mesh: .generateBox(size: [1000, 0, 1000]), materials: [OcclusionMaterial()])
        floorModel.physicsBody = .init(material: .generate(), mode: .static)
        floorModel.generateCollisionShapes(recursive: true)
        
        floorAnchor.addChild(floorModel) 
        arView.scene.addAnchor(floorAnchor)
        
        context.coordinator.view = arView
        return arView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
