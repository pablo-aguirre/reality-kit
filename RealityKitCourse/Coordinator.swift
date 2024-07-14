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
    
    
    func setup() {
        guard let view = self.view else { return }
        
        let anchor = AnchorEntity(plane: .horizontal)
        
        let material = OcclusionMaterial()
        let box = ModelEntity(mesh: .generateBox(size: 0.3), materials: [material])
        box.generateCollisionShapes(recursive: true)
        view.installGestures(for: box)
        
        cancellable = ModelEntity.loadAsync(named: "robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    fatalError("Unable to load model \(error)")
                }
                
                self.cancellable?.cancel()
            },
            receiveValue: { entity in
                anchor.addChild(entity)
            }
        )
        
        anchor.addChild(box)
        view.scene.addAnchor(anchor)
    }
}
