//
//  InspirationDetailViewModel.swift
//  Project
//
//  Created by Catarina Polakowsky on 23.08.2024.
//

import Foundation
protocol InspirationDetailViewModelProtocol: AnyObject {}

final class InspirationDetailViewModel {
    private weak var view: InspirationDetailViewProtocol?
}

extension InspirationDetailViewModel: InspirationDetailViewModelProtocol {}
