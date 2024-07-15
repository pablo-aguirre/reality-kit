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
    private var startAnchor: AnchorEntity?
    private var endAnchor: AnchorEntity?
    
    lazy var measurementButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("0.00", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton(configuration: .gray(), primaryAction: UIAction(handler: { [weak self] action in
            guard let arView = self?.arView else { return }
            self?.startAnchor = nil
            self?.endAnchor = nil
            
            arView.scene.anchors.removeAll()
            self?.measurementButton.setTitle("0.00", for: .normal)
        }))
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reset", for: .normal)
        return button
    }()
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let arView = arView else { return }
        let tapLocation = recognizer.location(in: arView)
        
        if let result = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal).first {
            if startAnchor == nil {
                startAnchor = AnchorEntity(raycastResult: result)
                startAnchor?.addChild(ModelEntity(mesh: .generateBox(size: 0.01), materials: [SimpleMaterial()]))
                
                guard let startAnchor = startAnchor else { return }
                arView.scene.addAnchor(startAnchor)
            } else if endAnchor == nil {
                endAnchor = AnchorEntity(raycastResult: result)
                endAnchor?.addChild(ModelEntity(mesh: .generateBox(size: 0.01), materials: [SimpleMaterial()]))
                guard let startAnchor = startAnchor,
                      let endAnchor = endAnchor else { return }
                arView.scene.addAnchor(endAnchor)
                
                let distance = simd_distance((startAnchor.position(relativeTo: nil)), endAnchor.position(relativeTo: nil))
                measurementButton.setTitle(String(format: "%.2f meters", distance), for: .normal)
            }
        }
        
    }
    
    func setupUI() {
        guard let arView = arView else { return }
        
        let stackView = UIStackView(arrangedSubviews: [measurementButton, resetButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        arView.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: arView.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: arView.bottomAnchor, constant: -60).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
}
