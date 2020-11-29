//
//  StateInstance.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 29/11/20.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

/// Workaround to use `StateObject` in _iOS 14_ and `ObservedObject` in _iOS 13_
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper struct StateInstance<ObjectType>: DynamicProperty where ObjectType: ObservableObject {

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    @ObservedObject private var observedObject: ObjectType

    private var _stateObject: Any?

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    private var stateObject: ObjectType? {
        _stateObject as? ObjectType
    }

    var wrappedValue: ObjectType {
        get {
            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                return stateObject ?? observedObject
            } else {
                return observedObject
            }
        }
        set {
            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                self._stateObject = StateObject(wrappedValue: newValue)
            }
            observedObject = newValue
        }
    }

    init(wrappedValue: ObjectType) {
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            self._stateObject = StateObject(wrappedValue: wrappedValue)
        }
        observedObject = wrappedValue
    }

}
