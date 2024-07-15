//
//  Coordinator.swift
//  RealityKitCourse
//
//  Created by Pablo Aguirre on 14/07/24.
//

import Foundation
import RealityKit
import ARKit

class Coordinator: NSObject, UIGestureRecognizerDelegate {
    
    weak var view: ARView?
    private var movableEntities = [MovableEntity]()
    
    func buildEnvironment() {
        guard let view = self.view else { return }
        
        let anchor = AnchorEntity(plane: .horizontal)
        
        let floor = ModelEntity(mesh: .generatePlane(width: 0.5, depth: 0.5), materials: [SimpleMaterial()])
        floor.generateCollisionShapes(recursive: true)
        floor.physicsBody = .init(material: .default, mode: .static)
        
        movableEntities.append(.init(size: 0.1, color: .green, shape: .box))
        movableEntities.append(.init(size: 0.1, color: .green, shape: .box))
        movableEntities.append(.init(size: 0.1, color: .green, shape: .sphere))
        movableEntities.append(.init(size: 0.1, color: .green, shape: .sphere))
        
        movableEntities.forEach { movableEntity in
            anchor.addChild(movableEntity)
            view.installGestures(for: movableEntity).forEach { $0.delegate = self }
        }
        setupGestures()
        
        anchor.addChild(floor)
        view.scene.addAnchor(anchor)
    }
    
    func setupGestures() {
        guard let view = self.view else { return }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func panned(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .ended, .cancelled, .failed:
            movableEntities.forEach { $0.physicsBody?.mode = .dynamic }
        default:
            return
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureREcognizer: UIGestureRecognizer) -> Bool {
        guard let translationGesture = gestureRecognizer as? EntityTranslationGestureRecognizer,
              let entity = translationGesture.entity as? MovableEntity else { return true }
        
        entity.physicsBody?.mode = .kinematic
        return true
    }
}
