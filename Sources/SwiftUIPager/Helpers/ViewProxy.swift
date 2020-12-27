//
//  ViewProxy.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 27/12/20.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

/// Proxy to inject an `ObservableObject` as a `StateObject`
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct StateObjectViewProxy<Property: ObservableObject, Content: View>: View {

    @StateObject private var observableProperty: Property
    let content: (Property) -> Content

    init(property: Property, @ViewBuilder content: @escaping (Property) -> Content) {
        self._observableProperty = StateObject(wrappedValue: property)
        self.content = content
    }

    var body: some View {
        content(observableProperty)
    }

}

/// Proxy to inject an `ObservableObject` as a `ObservedObject`
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct ObservedObjectViewProxy<Property: ObservableObject, Content: View>: View {

    @ObservedObject private var observableProperty: Property
    let content: (Property) -> Content

    init(property: Property, @ViewBuilder content: @escaping (Property) -> Content) {
        self.observableProperty = property
        self.content = content
    }

    var body: some View {
        content(observableProperty)
    }

}
