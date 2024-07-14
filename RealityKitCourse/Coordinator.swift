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
    private var cancellable: Cancellable?
    
    func setup() {
        guard let view = self.view else { return }
        
        let anchor = AnchorEntity(plane: .horizontal)
        let mesh = MeshResource.generateBox(width: 0.1, height: 0.1, depth: 0.1, splitFaces: true)
        let box = ModelEntity(mesh: mesh)
        
        cancellable = TextureResource.loadAsync(named: "lola")
            .append(TextureResource.loadAsync(named: "purple_flower"))
            .append(TextureResource.loadAsync(named: "DSC_0003.JPG"))
            .append(TextureResource.loadAsync(named: "DSC_0117.JPG"))
            .append(TextureResource.loadAsync(named: "DSC_0171.JPG"))
            .append(TextureResource.loadAsync(named: "cover.jpg"))
            .collect().sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { fatalError("Unable to load texture: \(error)")}
                self?.cancellable?.cancel()
            }, receiveValue: { textures in
                var materials = [UnlitMaterial]()
                
                textures.forEach { texture in
                    var material = UnlitMaterial()
                    material.color = .init(tint: .white, texture: .init(texture))
                    materials.append(material)
                }
                box.model?.materials = materials
                anchor.addChild(box)
                view.scene.addAnchor(anchor)
            })
    }
}
