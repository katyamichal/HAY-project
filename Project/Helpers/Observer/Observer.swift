//
//  Observer.swift
//  Project
//
//  Created by Catarina Polakowsky on 15.07.2024.
//

import Foundation

extension NSObject {
    static var className: String {
        String(describing: Self.self)
    }
}

protocol IObserver: AnyObject {
    var id: UUID { get }
    func update<T>(with value: T)
}

final class Observer: IObserver {
    var id: UUID
    
    init(id: UUID) {
        self.id = id
    }
    
    func update<T>(with value: T) {
       print("Observer\(id): newValue: \(value)")
    }
}

protocol IObservable: AnyObject {
    associatedtype T
    var value: T? { get set }
    var observers: [IObserver] { get }
    
    func subscribe(observer: IObserver)
    func unsubscribe(observer: IObserver)
}

final class Observable<ViewData>: IObservable {
    
    typealias T = ViewData
    
    var value: ViewData? {
        didSet {
            self.notify(newValue: self.value)
        }
    }
    
    init(_ value: ViewData? = nil) {
        self.value = value
    }
    
    var observers: [IObserver] = []
    
    func subscribe(observer: IObserver) {
        observers.append(observer)
    }
    
    func unsubscribe(observer: IObserver) {
        observers.removeAll { obser in
            obser.id == observer.id
        }
    }
    
    func notify<ViewData>(newValue: ViewData) {
        observers.forEach { observer in
            observer.update(with: newValue)
        }
    }
}
