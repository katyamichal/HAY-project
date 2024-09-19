//
//  DesignerDetailViewController.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import UIKit

enum DesignerDetailsSection: Int, CaseIterable {
    case designerInfo
    case designerCollectionImagesPart1
    case quote1
    case designerCollectionImagesPart2
    case quote2
    case products
}

protocol IDesignerDetailView: AnyObject {
    func viewIsSetUp()
}

final class DesignerDetailViewController: UIViewController {
    
    private var designerDetailsView: DesignerDetailsView { return self.view as! DesignerDetailsView }
    private let viewModel: IDesignerDetailsViewModel
    var id: UUID
    
    // MARK: - Inits
    
    init(viewModel: IDesignerDetailsViewModel) {
        self.viewModel = viewModel
        id = UUID()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DesignerDetailViewController deinit")
    }
    
    // MARK: - Cycle
    
    override func loadView() {
        view = DesignerDetailsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setupView(view: self)
        setupCollectionViewDelegates()
        viewModel.subscribe(observer: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "HAY"
    }
}

// MARK: - IDesignerDetailView Protocol

extension DesignerDetailViewController: IDesignerDetailView {
    func viewIsSetUp() {
        viewModel.getData()
    }
}

// MARK: - Collection DataSource

extension DesignerDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        DesignerDetailsSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = DesignerDetailsSection.allCases[section]
        switch section {
        case .designerInfo: return 1
        case .quote1: return 1
        case .quote2: return 1
        case .designerCollectionImagesPart1: return viewModel.collectionImagesPart1.count
        case .designerCollectionImagesPart2: return viewModel.collectionImagesPart2.count
            
        case .products: return viewModel.productCount
        }
    }
    // TODO: - Fix hardcoding

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = DesignerDetailsSection.allCases[indexPath.section]
        
        switch section {
        case .designerInfo:
            return dequeueAndConfigureCell(collectionView, indexPath: indexPath, identifier: DesignerInfoCollectionCell.reuseIdentifier) { (cell: DesignerInfoCollectionCell) in
                cell.update(name: viewModel.collaborationName, designerImage: viewModel.designerImage, designerBio: viewModel.designerDescription)
            }
            
        case .quote1:
            return dequeueAndConfigureCell(collectionView, indexPath: indexPath, identifier: TextCollectionCell.reuseIdentifier) { (cell: TextCollectionCell) in
                cell.update(quote: viewModel.designerQuotesPart1)
            }
            
        case .quote2:
            return dequeueAndConfigureCell(collectionView, indexPath: indexPath, identifier: TextCollectionCell.reuseIdentifier) { (cell: TextCollectionCell) in
                cell.update(quote: viewModel.designerQuotesPart2)
            }
            
        case .designerCollectionImagesPart1:
            return dequeueAndConfigureCell(collectionView, indexPath: indexPath, identifier: DesignerCollectionImages.reuseIdentifier) { (cell: DesignerCollectionImages) in
                cell.update(with: viewModel.collectionImagesPart1[indexPath.item])
            }

        case .designerCollectionImagesPart2:
            return dequeueAndConfigureCell(collectionView, indexPath: indexPath, identifier: DesignerCollectionImages.reuseIdentifier) { (cell: DesignerCollectionImages) in
                cell.update(with: viewModel.collectionImagesPart2[indexPath.item])
            }

        case .products:
            return dequeueAndConfigureCell(collectionView, indexPath: indexPath, identifier: BasicCollectionViewCell.reuseIdentifier) { (cell: BasicCollectionViewCell) in
                viewModel.setCurrentProduct(at: indexPath.item)
                cell.update(productName: viewModel.productName, price: viewModel.productPrice, image: viewModel.productImage, isFavourite: viewModel.isFavourite, productId: viewModel.productId)
            }
        }
    }
}

// MARK: - CollectionView Delegate

extension DesignerDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = DesignerDetailsSection.allCases[indexPath.section]
        switch section {
        case .products: viewModel.showDetail(at: indexPath.item)
        default: break
        }
    }
}


// MARK: - Observer subscription

extension DesignerDetailViewController: IObserver {
    func update<T>(with value: T) {
        if value is DesignerDetailsViewData {
            DispatchQueue.main.async { [weak self] in
                self?.designerDetailsView.updateView()
            }
        }
    }
}

// MARK: - Private methods

private extension DesignerDetailViewController {
    func setupCollectionViewDelegates() {
        designerDetailsView.setupDataSource(self)
        designerDetailsView.setupCollectionDelegate(self)
    }
    
    func dequeueAndConfigureCell<CellType: UICollectionViewCell>(_ collectionView: UICollectionView, indexPath: IndexPath, identifier: String, configure: (CellType) -> Void) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CellType else {
            return UICollectionViewCell()
        }
        configure(cell)
        return cell
    }
}
