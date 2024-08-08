//
//  ArrayDataSource.swift
//  Project
//
//  Created by Catarina Polakowsky on 19.07.2024.
//

import UIKit

class ArrayDataSource<T>: NSObject {
    var data: Observable<[T]> = Observable([])
}


class TableDataSource: ArrayDataSource<Any>, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellVM = self.data.value?[indexPath.row]
        let section = TableSections.allCases[indexPath.section]
//        
//  
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: , for: indexPath) as?  else {
//                fatalError("Cell not exists in storyboard")
//            }
          
            return UITableViewCell()
        }
    }



class DynamicValue<T> {
    
    typealias CompletionHandler = ((T?) -> Void)
    
    var value : T? {
        didSet {
            self.notify()
        }
    }
    
    private var observers = [String: CompletionHandler]()
    
    init( value: T?) {
        self.value = value
    }
    
    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }
    
    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    
    private func notify() {
        observers.forEach({ $0.value(value) })
    }
    
    deinit {
        observers.removeAll()
    }
}

