//
//  Coordinator.swift
//  RealityKitCourse
//
//  Created by Pablo Aguirre on 14/07/24.
//

import Foundation
import ARKit
import RealityKit

class Coordinator: NSObject, ARSessionDelegate {
    
    weak var view: ARView?
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        let tapLocation = recognizer.location(in: view)
        
        if let entity = view.entity(at: tapLocation) as? ModelEntity {
            let material = SimpleMaterial(color: .random(), isMetallic: false)
            entity.model?.materials = [material]
        }
    }
}
