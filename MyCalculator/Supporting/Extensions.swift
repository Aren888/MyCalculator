//
//  Extensions.swift
//  MyCalculator
//
//  Created by Aren Musayelyan on 29.05.23.
//

import Foundation
import UIKit

extension Double {
    var toInt: Int? {
        return Int(self)
    }
}

extension String {
    var toDouble: Double? {
        return Double(self)
    }
}

extension FloatingPoint {
    var isInteger: Bool { return rounded() == self }
}
