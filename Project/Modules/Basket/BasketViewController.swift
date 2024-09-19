//
//  BasketViewController.swift
//  Project
//
//  Created by Catarina Polakowsky on 19.09.2024.
//

import UIKit

protocol IBasketView: AnyObject {

}

final class BasketViewController: UIViewController {
    private let viewModel: IBasketViewModel
    private var basketView: BasketView { return self.view as! BasketView }
    
    
    // MARK: - Inits

    init(viewModel: IBasketViewModel) {
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
        viewModel.setupView(with: self)
        viewModel.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
}

extension BasketViewController: IBasketView {}

// MARK: - scroll to the top of the screen
//
//extension BasketViewController: TabBarReselectHandling {
//    func handleReselect() {
//        basketView.tableView.setContentOffset(.zero, animated: true)
//    }
//}



extension BasketViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return BasketTableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = BasketTableSection.allCases[indexPath.section]
        switch section {
            
        case .products:
            let cell = tableView.dequeue(indexPath) as BasketProductTableCell
            return cell
            
        case .orderInfo:
            let cell = tableView.dequeue(indexPath) as OrderInfoTableCell
            return cell
        }
    }
}

extension BasketViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        guard indexPath.section == 0 else { return false}
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        
//        guard let deleteAction = createDeleteAction(indexPath: indexPath),
//              let likeAction = createLikeAction(indexPath: indexPath),
//              indexPath.section == 0
//        else { return nil }
//        
//        
//        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
//        swipe.performsFirstActionWithFullSwipe = false
//        return swipe
//        
//    }
//    
//    private func createDeleteAction(indexPath: IndexPath) -> UIContextualAction? {
//        
//        guard let viewModel else { return nil }
//        
//        // нужен ли тут [captured list]?
//        
//        let deleteAction = UIContextualAction(style: .normal, title: "remove") { _, _, _ in
//        let product = viewModel.productsToBuy[indexPath.row]
//            
//            self.onDeleteProduct?(product, Int(indexPath.row))
//            self.tableView.beginUpdates()
//            self.tableView.deleteRows(at: [indexPath], with: .left)
//            self.tableView.endUpdates()
//            
//            /// обновить общую сумму покупки
//            let orderIndexPath = IndexPath(row: 0, section: 1)
//            guard let cell = self.tableView.cellForRow(at: orderIndexPath) as? OrderInfoTableCell else {return}
//            cell.update(orderInfo: viewModel.orderInfo)
//            
//            /// если мы удалили все продукты
//            if viewModel.productsToBuy.count == 0 {
//                self.tableView.isHidden = true
//                self.headerLabel.text = viewModel.emptyMessage
//            }
//        }
//        deleteAction.image = UIImage(systemName: "multiply")
//        deleteAction.backgroundColor = .black
//        return deleteAction
//    }
//    
//    private func createLikeAction(indexPath: IndexPath) -> UIContextualAction? {
//        guard let viewModel else { return nil }
//        let likeAction = UIContextualAction(style: .normal, title: "to favourite") { action, _, _ in
//            let product = viewModel.productsToBuy[indexPath.row]
//            
//           // self.onLikeDidTapped?(product, indexPath.row)
//            
////            self.tableView.beginUpdates()
//////            self.tableView.reloadRows(at: [indexPath], with: .right)
////            self.tableView.endUpdates()
//          
////            if viewModel.productsToBuy[indexPath.row].isFavourite {
////                action.image = UIImage(systemName: "heart.fill")
////            } else {
////                action.image = UIImage(systemName: "heart")
////            }
//        }
//   
//        likeAction.backgroundColor = Colours.Main.hayAccent
//        return likeAction
//    }
}
