//
//  MovableEntity.swift
//  RealityKitCourse
//
//  Created by Pablo Aguirre on 15/07/24.
//

import UIKit
import RealityKit

enum Shape {
    case box
    case sphere
}

class MovableEntity: Entity, HasModel, HasPhysics, HasCollision {
    var size: Float!
    var color: UIColor!
    var shape: Shape = .box
        
    required init() { fatalError("init() has not been implemented") }
    
    init(size: Float, color: UIColor, shape: Shape) {
        super.init()
        self.size = size
        self.color = color
        self.shape = shape
        
        self.model = ModelComponent(mesh: generateMeshResource(), materials: [generateMaterial()])
        self.physicsBody = .init(massProperties: .default, material: .default, mode: .dynamic)
        self.collision = .init(shapes: [generateShapeResource()], mode: .trigger, filter: .sensor)
        self.generateCollisionShapes(recursive: true)
    }
    
    private func generateMeshResource() -> MeshResource {
        switch shape {
        case .box:
            return .generateBox(size: [size, size, size])
        case .sphere:
            return .generateSphere(radius: size)
        }
    }
    
    private func generateMaterial() -> Material {
        SimpleMaterial(color: color, isMetallic: false)
    }
    
    private func generateShapeResource() -> ShapeResource {
        switch shape {
        case .box:
            return .generateBox(size: [size, size, size])
        case .sphere:
            return .generateSphere(radius: size)
        }
    }

}
