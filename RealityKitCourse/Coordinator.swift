//
//  Coordinator.swift
//  RealityKitCourse
//
//  Created by Pablo Aguirre on 14/07/24.
//

import Foundation
import ARKit
import RealityKit
import Combine

class Coordinator {
    
    weak var view: ARView?
    private var cancellable: AnyCancellable?
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        
        let tapLocation = recognizer.location(in: view)
        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            let anchor = AnchorEntity(raycastResult: result)
            
            cancellable = ModelEntity.loadAsync(named: "robot")
                .append(ModelEntity.loadAsync(named: "sneaker"))
                .collect()
                .sink { loadCompletion in
                    if case let .failure(error) = loadCompletion {
                        print("Unable to load model \(error).")
                    }
                    self.cancellable?.cancel()
                } receiveValue: { entities in
                    var x: Float = 0.0
                    
                    entities.forEach { entity in
                        entity.position = simd_make_float3(x, 0, 0)
                        anchor.addChild(entity)
                        x += 0.3
                    }
                }
            
            view.scene.addAnchor(anchor)
        }
    }
}
