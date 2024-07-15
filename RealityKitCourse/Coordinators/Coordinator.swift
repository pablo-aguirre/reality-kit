//
//  Coordinator.swift
//  RealityKitCourse
//
//  Created by Pablo Aguirre on 15/07/24.
//

import Foundation
import RealityKit
import SwiftUI

class Coordinator {
    var arView: ARView?
    
    func setupUI() {
        guard let arView = arView else { return }
        
        let anchor = AnchorEntity(.image(group: "AR Resources", name: "imac-21"))
        let boxModel = ModelEntity(mesh: .generateBox(size: 0.2), materials: [SimpleMaterial()])
        anchor.addChild(boxModel)
        arView.scene.addAnchor(anchor)
    }
}
