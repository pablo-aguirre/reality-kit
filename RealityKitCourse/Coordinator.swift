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
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        let tapLocation = recognizer.location(in: view)
        
        if let result = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal).first {
            let anchorEntity = AnchorEntity(raycastResult: result)
            
            let boxEntity = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial()])
            boxEntity.physicsBody = .init(massProperties: .default, material: .generate(), mode: .dynamic)
            boxEntity.generateCollisionShapes(recursive: true)
            
            boxEntity.position = simd_make_float3(0, 0.7, 0)
            anchorEntity.addChild(boxEntity)
            view.scene.addAnchor(anchorEntity)
        }
        
    }
}
