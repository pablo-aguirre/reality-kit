//
//  Coordinator.swift
//  RealityKitCourse
//
//  Created by Pablo Aguirre on 14/07/24.
//

import Foundation
import ARKit
import RealityKit

class Coordinator {
    
    var view: ARView?
    
    func setup() {
        guard let view = self.view else { return }
        
        let anchor = AnchorEntity(plane: .horizontal)
        let mesh = MeshResource.generateBox(size: 0.1)
        let box = ModelEntity(mesh: mesh)
        
        if let texture = try? TextureResource.load(named: "purple_flower") {
            var material = UnlitMaterial()
            material.color = .init(tint: .white, texture: .init(texture))
            
            box.model?.materials = [material]
        }
        
        anchor.addChild(box)
        view.scene.addAnchor(anchor)
    }
}
