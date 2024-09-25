//
//  BasketViewController.swift
//  Project
//
//  Created by Catarina Polakowsky on 19.09.2024.
//

import UIKit

protocol IBasketView: AnyObject {
    func updateView(with status: Bool)
    func updateViewHeader()
    func updateRow(at index: Int)
}

final class BasketViewController: UIViewController {
    private let viewModel: IBasketViewModel
    private var basketView: BasketView { return self.view as! BasketView }
    var id: UUID
    private var isEditingRow: Bool = false
    
    // MARK: - Inits

    init(viewModel: IBasketViewModel) {
        id = UUID()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
       print("BasketViewController deinit")
    }
    
    // MARK: - Life Cycle

    override func loadView() {
        self.view = BasketView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDelegate()
        viewModel.setupView(with: self)
        viewModel.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - IBasketView protocol

extension BasketViewController: IBasketView {
    func updateView(with status: Bool) {
        status ? basketView.updateTableView() : basketView.hideTableView()
    }
    
    func updateViewHeader() {
        basketView.updateHeader(with: viewModel.headerTitle, and: viewModel.headerFont)
    }
    
    func updateRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        basketView.deleteRow(at: indexPath)
    }
}

// MARK: - TableView Data Source

extension BasketViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        BasketTableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = BasketTableSection.allCases[section]
        switch section {
        case .products: return viewModel.productsCount
        case .orderInfo: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = BasketTableSection.allCases[indexPath.section]
        switch section {
        case .products:
            let cell = tableView.dequeue(indexPath) as BasketProductTableCell
            viewModel.setCurrentProduct(at: indexPath.row)
            cell.update(productName: viewModel.productName, price: viewModel.price, image: viewModel.image, count: viewModel.countOfSingleProduct)
            return cell
            
        case .orderInfo:
            let cell = tableView.dequeue(indexPath) as OrderInfoTableCell
            cell.update(subtotal: viewModel.subtotalPrice, delivery: viewModel.deliveryPrice, total: viewModel.totalPrice)
            return cell
        }
    }
}

// MARK: - TableView Delegate

extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = BasketTableSection.allCases[indexPath.section]
        switch section {
        case .products: viewModel.showDetail(at: indexPath.row)
        case .orderInfo: break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = BasketTableSection.allCases[indexPath.section]
        return (section == .products) ? true : false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let deleteAction = createDeleteAction(indexPath: indexPath) {
            let section = BasketTableSection.allCases[indexPath.section]
            switch section {
            case .products:
                let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
                swipe.performsFirstActionWithFullSwipe = false
                return swipe
            case .orderInfo: return nil
            }
        }
        return nil
    }
}

// MARK: - Observer protocol

extension BasketViewController: IObserver {
    func update<T>(with value: T) {
        print(isEditingRow)
        if value is BasketProducts && (isEditingRow == false) {
            viewModel.getData()
        }
    }
}

// MARK: - Private methods

private extension BasketViewController {
    func setupTableViewDelegate() {
        basketView.setupTableViewDelegate(self)
        basketView.setupTableViewDataSource(self)
    }
    
    func createDeleteAction(indexPath: IndexPath) -> UIContextualAction? {
        let deleteAction = UIContextualAction(style: .normal, title: "remove") { [weak self] _, _, completionHandler in
            guard let self = self else {
                completionHandler(false)
                return
            }
            let tableView = self.basketView.tableView
            guard let cell = tableView.cellForRow(at: indexPath) else {
                completionHandler(false)
                return
            }
            isEditingRow = true
            completionHandler(true)
            self.viewModel.swapToDeleteFromBasket(at: indexPath.row)
            self.animateRowDeletion(tableView, on: cell, at: indexPath)
        }
        deleteAction.backgroundColor = .black
        deleteAction.image = UIImage(systemName: "multiply")
        return deleteAction
    }
    // MARK: - Delete Row Animation
    
    func animateRowDeletion(_ tableView: UITableView, on cell: UITableViewCell, at indexPath: IndexPath) {
        startFlashingAnimation(on: cell)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.stopFlashingAnimation(on: cell)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                tableView.deleteRows(at: [indexPath], with: .fade)
                if self.viewModel.productsCount == 0 {
                    self.basketView.hideTableView()
                    self.updateViewHeader()
                }
            }
            CATransaction.commit()
            self.isEditingRow = false
        }
    }
    
    func startFlashingAnimation(on cell: UITableViewCell) {
        let flashingAnimation = CABasicAnimation(keyPath: "backgroundColor")
        flashingAnimation.toValue = UIColor.gray.withAlphaComponent(0.1).cgColor
        flashingAnimation.duration = 0.5
        flashingAnimation.autoreverses = true
        flashingAnimation.repeatCount = .infinity
        cell.layer.add(flashingAnimation, forKey: "flashingAnimation")
        cell.alpha = 0.6
    }
    
    func stopFlashingAnimation(on cell: UITableViewCell) {
        cell.layer.removeAnimation(forKey: "flashingAnimation")
    }
}

// MARK: - scroll to the top of the screen
//
//extension BasketViewController: TabBarReselectHandling {
//    func handleReselect() {
//        basketView.tableView.setContentOffset(.zero, animated: true)
//    }
//}
