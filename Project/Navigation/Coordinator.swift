//
//  Coordinator.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import Foundation

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
    func finish()
}
