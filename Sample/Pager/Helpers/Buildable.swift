//
//  Buildable.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 09/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

protocol Buildable { }

extension Buildable {

    func mutating<T>(keyPath: WritableKeyPath<Self, T>, value: T) -> Self {
        var newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }

}
