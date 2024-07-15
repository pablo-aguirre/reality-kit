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
    
    var view: ARView?
    private var collisionSubscriptions = [Cancellable]()
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        let tapLocation = recognizer.location(in: view)
        
        if let result = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal).first {
            let anchorEntity = AnchorEntity(raycastResult: result)
            
            let boxModel = ModelEntity(mesh: .generateBox(size: 0.05), materials: [SimpleMaterial(color: .green, isMetallic: false)])
            boxModel.position.y = 0.3
            boxModel.generateCollisionShapes(recursive: true)
            boxModel.physicsBody = .init(massProperties: .default, material: .generate(), mode: .dynamic)
            
            boxModel.collision = .init(shapes: [.generateBox(size: [0.05, 0.05, 0.05])], mode: .trigger, filter: .sensor)
            
            collisionSubscriptions.append(view.scene.subscribe(to: CollisionEvents.Began.self) { event in
                boxModel.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
            })
            
            collisionSubscriptions.append(view.scene.subscribe(to: CollisionEvents.Ended.self) { event in
                boxModel.model?.materials = [SimpleMaterial(color: .green, isMetallic: false)]
            })
            
            anchorEntity.addChild(boxModel)
            view.scene.addAnchor(anchorEntity)
        }
        
    }
}
