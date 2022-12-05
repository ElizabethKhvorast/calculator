//
//  NSNumberExtensions.swift
//  calculator
//
//  Created by Елизавета Хворост on 16/11/2022.
//

import Foundation

extension NSNumber
{
    var isFraction: Bool {
        get {
            let decimalNumber = NSNumber(value: self.int64Value)
            return !self.isEqual(to: decimalNumber)
        }
    }
}
