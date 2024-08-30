//
//  HayTableViewSections.swift
//  Project
//
//  Created by Catarina Polakowsky on 29.08.2024.
//

import UIKit

protocol TableSectionProtocol {
    var numberOfRows: Int { get }
    func configureCell(for tableView: UITableView, at indexPath: IndexPath, with viewModel: HayViewModel) -> UITableViewCell
}

extension TableSectionProtocol {
    var numberOfRows: Int {
        1
    }
}

// MARK: - Section Types

enum TableSections: Int, CaseIterable {
    case category1, designer1, category2, designer2

    var isCategory: Bool {
        switch self {
        case .category1, .category2:
            return true
        default:
            return false
        }
    }
 
    var sectionIndex: Int {
        switch self {
        case .category1, .designer1:
            return 0
        case .category2, .designer2:
            return 1
        }
    }

    func sectionData(for viewModel: HayViewModel) -> TableSectionProtocol {
        if isCategory {
            return CategorySection(viewModel: viewModel, sectionIndex: sectionIndex)
        } else {
            return DesignerSection(viewModel: viewModel, sectionIndex: sectionIndex)
        }
    }
}

// MARK: - Category Section

struct CategorySection: TableSectionProtocol {
    let viewModel: HayViewModel
    let sectionIndex: Int

    func configureCell(for tableView: UITableView, at indexPath: IndexPath, with viewModel: HayViewModel) -> UITableViewCell {
        guard let viewData = viewModel.viewData.value,
              sectionIndex < viewData.categories.count
        else {
            return UITableViewCell()
        }
  
        let cell = tableView.dequeue(indexPath) as CategoryTableCell
        viewModel.createCategory(with: cell, at: sectionIndex)
        cell.update()
        return cell
    }
}

// MARK: - Category Section

struct DesignerSection: TableSectionProtocol {
    let viewModel: HayViewModel
    let sectionIndex: Int
    
    func configureCell(for tableView: UITableView, at indexPath: IndexPath, with viewModel: HayViewModel) -> UITableViewCell {
        guard let viewData = viewModel.viewData.value,
                sectionIndex < viewData.designers.count 
        else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeue(indexPath) as DesignerTableCell
        viewModel.createDesigner(with: cell, at: sectionIndex)
        cell.update()
        return cell
    }
}
