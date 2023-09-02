//
//  File.swift
//  
//
//  Created by feichao on 2022/9/25.
//

import Foundation

public protocol PagerData<Element> {
    associatedtype Element
    
    func itemFor(index: Int) -> Element
    
    var count: Int { get }
}


struct PagerWrapperData<Element, ID> where Element: Equatable, ID: Hashable {
    let wrapper: any PagerData<Element>
    let id: KeyPath<Element, ID>
    var repeating: Int
    
    init<T: PagerData<Element>>(wrapper: T, id: KeyPath<Element, ID>, repeating: Int = 1) {
        self.wrapper = wrapper
        self.id = id
        self.repeating = repeating
    }
    
    func itemFor(index: Int) -> PageWrapper<Element, ID> {
        assert(index < count * repeating)
        let batch = index / count
        let item = wrapper.itemFor(index: index % count)
        return PageWrapper(batchId: UInt(batch), keyPath: id, element: item, indexInData: index)
    }
    
    var count: Int {
        wrapper.count * repeating
    }
    
    subscript(index: Int) -> PageWrapper<Element, ID> {
        return itemFor(index: index)
    }
    
    func withRepeating(repeating: Int) -> Self {
        var new = self
        new.repeating = repeating
        return new
    }
}

extension Array: PagerData {
    public func itemFor(index: Int) -> Element {
        self[index]
    }
}
