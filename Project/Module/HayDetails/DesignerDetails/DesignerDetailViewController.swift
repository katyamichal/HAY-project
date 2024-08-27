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

final class DesignerDetailViewController: UIViewController, IDesignerView {
    
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
            
        case .products: return viewModel.productsCount
        }
    }
    // TODO: - Fix hardcoding

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = DesignerDetailsSection.allCases[indexPath.section]
        switch section {
            
        case .designerInfo:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesignerInfoCollectionCell.reuseIdentifier, for: indexPath) as? DesignerInfoCollectionCell else {
                return UICollectionViewCell()
            }
            cell.update(name: viewModel.collaborationName, designerImage: viewModel.designerImage, designerBio: viewModel.designerDescription)
            return cell
            
        case .quote1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseIdentifier, for: indexPath) as? TextCollectionCell else {
                return UICollectionViewCell()
            }
            cell.update(quote: viewModel.designerQuotesPart1)
            return cell
            
        case .quote2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseIdentifier, for: indexPath) as? TextCollectionCell else {
                return UICollectionViewCell()
            }
            cell.update(quote: viewModel.designerQuotesPart2)
            return cell
 
        case .designerCollectionImagesPart1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesignerCollectionImages.reuseIdentifier, for: indexPath) as? DesignerCollectionImages else {
                return UICollectionViewCell()
            }
            cell.update(with: viewModel.collectionImagesPart1[indexPath.item])
            return cell

        case .designerCollectionImagesPart2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesignerCollectionImages.reuseIdentifier, for: indexPath) as? DesignerCollectionImages else {
                return UICollectionViewCell()
            }
            cell.update(with: viewModel.collectionImagesPart2[indexPath.item])
            return cell
            
        case .products:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesignerProductsCollectionCell.reuseIdentifier, for: indexPath) as? DesignerProductsCollectionCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
}

extension DesignerDetailViewController: IObserver {
    func update<T>(with value: T) {
        if value is DesignerDetailsViewData {
            DispatchQueue.main.async { [weak self] in
                self?.designerDetailsView.updateView()
            }
        }
    }
}

private extension DesignerDetailViewController {
    func setupCollectionViewDelegates() {
        designerDetailsView.setupDataSource(self)
    }
}
