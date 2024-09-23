//
//  BasketViewController.swift
//  Project
//
//  Created by Catarina Polakowsky on 19.09.2024.
//

import UIKit

protocol IBasketView: AnyObject {
    func updateView()
    func updateViewHeader()
}

final class BasketViewController: UIViewController {
    private let viewModel: IBasketViewModel
    private var basketView: BasketView { return self.view as! BasketView }
    
    var id: UUID
    
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

extension BasketViewController: IBasketView {
    func updateView() {
        basketView.updateTableView()
    }
    
    func updateViewHeader() {
        basketView.updateHeader(with: viewModel.headerTitle, and: viewModel.headerFont)
    }
}

// MARK: - scroll to the top of the screen
//
//extension BasketViewController: TabBarReselectHandling {
//    func handleReselect() {
//        basketView.tableView.setContentOffset(.zero, animated: true)
//    }
//}

// MARK: - TableView Data Source

extension BasketViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return BasketTableSection.allCases.count
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
        switch section {
        case .products: return true
        case .orderInfo: return false
        }
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
    
    private func createDeleteAction(indexPath: IndexPath) -> UIContextualAction? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "remove") { [weak self] _, _, _ in
          //  viewModel.deleteProduct(with: <#T##Int#>, at: <#T##Int#>)
            
//            let product = viewModel.productsToBuy[indexPath.row]
            
//            self?.onDeleteProduct?(product, Int(indexPath.row))
            
//            self?.tableView.beginUpdates()
//            self?.tableView.deleteRows(at: [indexPath], with: .left)
//            self?.tableView.endUpdates()
            
            //            /// обновить общую сумму покупки
            //            let orderIndexPath = IndexPath(row: 0, section: 1)
            //            guard let cell = self.tableView.cellForRow(at: orderIndexPath) as? OrderInfoTableCell else {return}
            //
            //
            //            if viewModel.productsToBuy.count == 0 {
            //                self.tableView.isHidden = true
            //                self.headerLabel.text = viewModel.emptyMessage
            //            }
        }
        deleteAction.image = UIImage(systemName: "multiply")
        
        return deleteAction
    }
}

extension BasketViewController: IObserver {
    func update<T>(with value: T) {
        if value is BasketProducts {
            viewModel.getData()
        }
    }
}

private extension BasketViewController {
    func setupTableViewDelegate() {
        basketView.setupTableViewDelegate(self)
        basketView.setupTableViewDataSource(self)
    }
}

