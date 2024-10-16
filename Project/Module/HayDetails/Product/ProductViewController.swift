//
//  ProducViewController.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.07.2024.
//

import UIKit

// so activity controller works on the main thread which makes it tricky for using or sending large objects
// UIActivityItemProvider -- better to use if it takes time to create large data objects

private enum Sections: Int, CaseIterable {
    case productImages = 1
    case productInfo
}

protocol IProductView: AnyObject {
    func unsubscribe()
    func viewIsSetUp()
    func updateView(with status: Bool, and productId: Int)
    func updateBasketButton(with title: String)
}

final class ProducViewController: UIViewController {
    
    private let viewModel: IProductViewModel
    private var productView: ProductView { return self.view as! ProductView }
    var id: UUID
    // MARK: - Init
    
    init(viewModel: IProductViewModel) {
        self.viewModel = viewModel
        self.id = UUID()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ProducViewController deinit")
    }
    
    // MARK: - Cycle
    
    override func loadView() {
        self.view = ProductView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButton()
        viewModel.setupView(with: self)
        setupTabelView()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
}

extension ProducViewController: IProductView {
    func unsubscribe() {
        viewModel.unsubscribe(observer: self)
    }
    
    func updateView(with status: Bool, and productId: Int) {
        productView.updateActivityView(isFavouriteStatus: status, productId: productId)
    }
    
    func updateBasketButton(with title: String) {
        productView.updateBasketButtonTitle(with: title)
    }
    
    func viewIsSetUp() {
        viewModel.fetchData()
    }
}

// MARK: - TableView Data Source

extension ProducViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Sections.allCases[section]
        switch section {
        case .productImages:
            return section.rawValue
        case .productInfo:
            return viewModel.productInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Sections.allCases[indexPath.section]
        switch section {
        case .productImages:
            let cell = tableView.dequeue(indexPath) as ProductGaleryCell
            cell.update(name: viewModel.productName, description: viewModel.description, images: viewModel.images)
            return cell
            
        case .productInfo:
            let cell = tableView.dequeue(indexPath) as ProductInfoCell
            let type = viewModel.productInfo[indexPath.row]
            for (key, value) in type {
                cell.update(infoType: key, infoDesscription: value)
            }
            return cell
        }
    }
}

extension ProducViewController: IObserver {
    func update<T>(with value: T) {
        if value is ProductViewData {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.productView.updateView(isFavouriteStatus: strongSelf.viewModel.isFavourite, productId: strongSelf.viewModel.productId)
                strongSelf.productView.updateBasketButtonTitle(with: strongSelf.viewModel.buttonTitle)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.productView.updateView(with: "Error")
            }
        }
    }
}

// MARK: - TableView Delgate

extension ProducViewController: UITableViewDelegate {}

private extension ProducViewController {
    func setupTabelView() {
        productView.setupTableViewDelegate(with: self)
        productView.setupTableViewDataSource(with: self)
    }
    
    func setupNavBarButton() {
        navigationItem.title = Constants.LabelTitles.navigationBarHay
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
        
        let image = UIImage(systemName: Constants.SystemUIElementNames.goBack, withConfiguration: config)?.withTintColor(.black)
        let leftBarButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(backButtonDidTapped))
        
        let image2 = UIImage(systemName: Constants.SystemUIElementNames.share, withConfiguration: config)
        let rightBarButton = UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(shareProduct))
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setupActions() {
        guard let delegate = viewModel as? ILikeButton else {
           return
        }
        productView.setupLikeButtonDelegate(delegate)
    }
    
    @objc
    func backButtonDidTapped() {
        viewModel.goBack()
    }
    
    // TODO: -  clean up

    @objc
    func shareProduct() {
        let productName = viewModel.productName
        let url = URL(string: "https://hay.dk")!
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityVC.title = productName
        activityVC.excludedActivityTypes = [.airDrop]
        self.present(activityVC, animated: true)
    }
}
