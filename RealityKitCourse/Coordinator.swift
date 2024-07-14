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
    
    weak var view: ARView?
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        
        let tapLocation = recognizer.location(in: view)
        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            let anchorEntity = AnchorEntity(raycastResult: result)
            let modelEntity = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .random(), isMetallic: false)])
            modelEntity.generateCollisionShapes(recursive: true)
            anchorEntity.addChild(modelEntity)
            
            view.scene.addAnchor(anchorEntity)
            view.installGestures(.all, for: modelEntity)
        }
    }
}
