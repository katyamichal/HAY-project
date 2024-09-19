//
//  HayViewController.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import UIKit

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
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - IHayViewController

extension HayViewController: IHayViewController {
    func viewIsSetUp() {
        hayViewModel.fetchServerData()
    }
}

// MARK: - TableView Data Source

extension HayViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSections.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = TableSections(rawValue: section) else { return 0 }
        return sectionType.sectionData(for: hayViewModel).numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = TableSections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        return sectionType.sectionData(for: hayViewModel).configureCell(for: tableView, at: indexPath, with: hayViewModel)
    }
}

// MARK: - TableView Delegate

extension HayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = TableSections(rawValue: indexPath.section)!
        guard let designers = hayViewModel.viewData.value?.designers else { return }
        
        switch section {
        case .category1, .category2:
            break
        case .designer1, .designer2:
            let designerIndex = section.sectionIndex
            guard designerIndex < designers.count else { return }
            hayViewModel.showDesignerDetail(designerId: designers[designerIndex].id)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let sectionType = TableSections(rawValue: indexPath.section) else { return }
        
        sectionType.sectionData(for: hayViewModel).dequeueCellModule(for: tableView, at: indexPath, with: hayViewModel)
    }
}

// MARK: - Observer Subscription

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

// MARK: - Private methods

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
