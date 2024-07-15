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
}
