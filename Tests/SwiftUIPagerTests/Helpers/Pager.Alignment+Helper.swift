//
//  File.swift
//  
//
//  Created by Fernando Moya de Rivas on 05/02/2020.
//

import Foundation
import SwiftUIPager

extension PositionAlignment: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.center, .center):
            return true
        case (.start(let leftInsets), .start(let rightInsets)), (.end(let leftInsets), .end(let rightInsets)):
            return leftInsets == rightInsets
        default:
            return false
        }
    }

}
