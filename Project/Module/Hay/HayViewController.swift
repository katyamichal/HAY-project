//
//  HayViewController.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import UIKit


enum TableSections: Int, CaseIterable {
   case category1 = 0
   case designer1
   case category2
   case designer2
}

protocol IHayViewController: AnyObject {
    func viewIsSetUp()
}

final class HayViewController: UIViewController {
    var id: UUID
    private let hayViewModel: HayViewModel
    private var hayView: HayView { return self.view as! HayView }
    
    // MARK: - Inits
    
    init(mainViewModel: HayViewModel) {
        self.id = UUID()
        self.hayViewModel = mainViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("MainViewController deinit")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = HayView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHayView()
        hayViewModel.setupView(with: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - IHayViewController

extension HayViewController: IHayViewController {
    func viewIsSetUp() {
        hayViewModel.fetchServerData()
    }
}

extension HayViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewData = hayViewModel.viewData.value else {
            return UITableViewCell()
        }
        
        let section = TableSections.allCases[indexPath.section]
        
        switch section {
        case .category1, .category2:
            let index = section == .category1 ? indexPath.row : indexPath.row + 1
            guard index < viewData.categories.count else {
                return UITableViewCell()
            }
            
            let cell = tableView.dequeue(indexPath) as CategoryTableCell
            hayViewModel.createCategory(with: cell, at: index)
            cell.update()
            return cell
        
            // TODO: - Separete logic into a concrete module

        case .designer1, .designer2:
            let index = section == .designer1 ? indexPath.row : indexPath.row + 1
            guard index < viewData.categories.count else {
                return UITableViewCell()
            }
            let designers = viewData.designers
            let cell = tableView.dequeue(indexPath) as DesignerTableCell
            
            
            if section == .designer1 {
                let designer = designers[indexPath.row]
                cell.update(sectionName: Constants.LabelTitle.designerSection, name: designer.designerName, collectionName: designer.collectionName, image: UIImage(named: designer.designerImage)!, products: designer.products)
            } else {
                let designer = designers[indexPath.row + 1]
                cell.update(sectionName: Constants.LabelTitle.designerSection, name: designer.designerName, collectionName: designer.collectionName, image: UIImage(named: designer.designerImage)!, products: designer.products)
            }
            return cell
        }
    }
}

extension HayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = TableSections.allCases[indexPath.section]
        switch section {
        case .category1, .category2:
            break
        case .designer1, .designer2:
        print("Should show designer detail")
          //  hayViewModel.showDetail()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

extension HayViewController: IObserver {
    func update<T>(with value: T) {
        if value is HayViewData {
            DispatchQueue.main.async { [weak self] in
                self?.update()
                self?.updateHeader()
            }
        } else {
            update(errorMessage: value as! String)
        }
    }
}

private extension HayViewController {
    func setupHayView() {
        hayView.setupDataSource(with: self)
        hayView.setupTableViewDelegate(with: self)
    }
    
    func update() {
        hayView.tableView.reloadData()
    }
    
    func update(errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.hayView.showErrorMessage = errorMessage
        }
    }
    
    func updateHeader() {
        hayViewModel.createInspiration(with: hayView.tableView.tableHeader)
        hayView.tableView.tableHeader.setupViewModel()
    }
}

// MARK: -  Scroll View Delegate to Scroll Header

extension HayViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hayView.tableView.scrollHeader()
    }
}
