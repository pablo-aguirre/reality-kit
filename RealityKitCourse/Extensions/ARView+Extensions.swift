//
//  ARView+Extensions.swift
//  RealityKitCourse
//
//  Created by Pablo Aguirre on 15/07/24.
//

import Foundation
import RealityKit
import ARKit

extension ARView {
    
    func addCoachingOverlay() {
        let coachingView = ARCoachingOverlayView()
        coachingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingView.goal = .horizontalPlane
        coachingView.session = self.session
        self.addSubview(coachingView)
    }
    
}
