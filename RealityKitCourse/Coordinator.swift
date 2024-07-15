//
//  Coordinator.swift
//  RealityKitCourse
//
//  Created by Pablo Aguirre on 14/07/24.
//

import Foundation
import RealityKit
import Combine

class Coordinator {
    
    weak var view: ARView?
    private var collisionSubscriptions = [Cancellable]()
    
    private let boxGroup = CollisionGroup(rawValue: 1 << 0)
    private let sphereGoup = CollisionGroup(rawValue: 1 << 1)
    
    func buildEnvironment() {
        guard let view = self.view else { return }
        
        let boxMask = CollisionGroup.all.subtracting(sphereGoup)
        let sphereMask = CollisionGroup.all.subtracting(boxGroup)
        
        // Box will only collide with spehere and sphere will only collide with box:
        // let boxMask = CollisionGroup.all.subtracting(boxGroup)
        // let sphereMask = CollisionGroup.all.subtracting(sphereGoup)
        
        let anchor = AnchorEntity(plane: .horizontal)
        
        let box1 = ModelEntity(mesh: .generateBox(size: 0.2), materials: [SimpleMaterial(color: .green, isMetallic: false)])
        box1.generateCollisionShapes(recursive: true)
        box1.collision = .init(shapes: [.generateBox(size: [0.2, 0.2, 0.2])], mode: .trigger, filter: .init(group: boxGroup, mask: boxMask))
        
        let box2 = ModelEntity(mesh: .generateBox(size: 0.2), materials: [SimpleMaterial(color: .green, isMetallic: false)])
        box2.generateCollisionShapes(recursive: true)
        box2.collision = .init(shapes: [.generateBox(size: [0.2, 0.2, 0.2])], mode: .trigger, filter: .init(group: boxGroup, mask: boxMask))
        box2.position.z = 0.3
        
        let sphere1 = ModelEntity(mesh: .generateSphere(radius: 0.2), materials: [SimpleMaterial(color: .green, isMetallic: false)])
        sphere1.generateCollisionShapes(recursive: true)
        sphere1.collision = .init(shapes: [.generateSphere(radius: 0.2)], mode: .trigger, filter: .init(group: sphereGoup, mask: sphereMask))
        sphere1.position.x += 0.3
        
        let sphere2 = ModelEntity(mesh: .generateSphere(radius: 0.2), materials: [SimpleMaterial(color: .green, isMetallic: false)])
        sphere2.generateCollisionShapes(recursive: true)
        sphere2.collision = .init(shapes: [.generateSphere(radius: 0.2)], mode: .trigger, filter: .init(group: sphereGoup, mask: sphereMask))
        sphere2.position.x -= 0.3
        
        anchor.addChild(box1)
        anchor.addChild(box2)
        anchor.addChild(sphere1)
        anchor.addChild(sphere2)
        view.scene.addAnchor(anchor)
        view.installGestures(for: box1)
        view.installGestures(for: box2)
        view.installGestures(for: sphere1)
        view.installGestures(for: sphere2)
        
        collisionSubscriptions.append(view.scene.subscribe(to: CollisionEvents.Began.self) { event in
            guard let entityA = event.entityA as? ModelEntity,
                  let entityB = event.entityB as? ModelEntity else { return }
            
            entityA.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
            entityB.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
        })
        
        collisionSubscriptions.append(view.scene.subscribe(to: CollisionEvents.Ended.self) { event in
            guard let entityA = event.entityA as? ModelEntity,
                  let entityB = event.entityB as? ModelEntity else { return }
            
            entityA.model?.materials = [SimpleMaterial(color: .green, isMetallic: false)]
            entityB.model?.materials = [SimpleMaterial(color: .green, isMetallic: false)]
        })
    }
    
}
