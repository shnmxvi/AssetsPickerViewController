//
//  ThreadSafe.swift
//
//

import Foundation

@propertyWrapper
class ThreadSafe<T> {
    private let queue: DispatchQueue
    
    private var _object: T
    
    convenience init(_ defaultValue: T) {
        self.init(
            DispatchQueue(label: "ThreadSafe", attributes: .concurrent),
            defaultValue)
    }
    
    init(_ queue: DispatchQueue,
                _ defaultValue: T) {
        self.queue = queue
        self._object = defaultValue
    }
    
    var value: T {
        get { return self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
    
    var wrappedValue: T {
        get { return self.queue.sync { self._object } }
        set { self.queue.sync(flags: .barrier) { self._object = newValue } }
    }
}
