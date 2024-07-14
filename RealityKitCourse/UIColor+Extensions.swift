//
//  UIColor+Extensions.swift
//  RealityKitCourse
//
//  Created by Pablo Aguirre on 14/07/24.
//

import Foundation
import UIKit

extension UIColor {
    static func random() -> UIColor {
        UIColor(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1), alpha: 1)
    }
}
