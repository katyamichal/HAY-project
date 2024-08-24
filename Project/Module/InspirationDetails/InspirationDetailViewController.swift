//
//  InspirationDetailViewController.swift
//  Project
//
//  Created by Catarina Polakowsky on 23.08.2024.
//

import UIKit

protocol InspirationDetailViewProtocol: AnyObject {
    
}

final class InspirationDetailViewController: UIViewController {
    
    private let viewModel: InspirationDetailViewModelProtocol
    private var inspirationDetailView: InspirationDetailView { return self.view as! InspirationDetailView }
    var id: UUID
    // MARK: - Inits
    
    init(viewModel: InspirationDetailViewModelProtocol) {
        self.viewModel = viewModel
        self.id = UUID()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("InspirationDetailViewController deinit")
    }
    
    // MARK: - Cycle
    
    override func loadView() {
        self.view = InspirationDetailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButton()
        viewModel.setupView(with: self)
        viewModel.subscribe(self)
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

extension InspirationDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        InspirationDetailSectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = InspirationDetailSectionType.allCases[section]
        switch sectionType {
        case .photoGalleryDescription: return 1
        case .products: return viewModel.productCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = InspirationDetailSectionType.allCases[indexPath.section]
      
        switch sectionType {
        case .photoGalleryDescription:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionCell.cellIdentifier, for: indexPath) as? GalleryCollectionCell else {
                return UICollectionViewCell()
            }
            cell.update(with: viewModel.collectionName, descriptionText: viewModel.description, images: viewModel.imageCollection)
            return cell

        case .products:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicCollectionViewCell.cellIdentifier, for: indexPath) as? BasicCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
}

extension InspirationDetailViewController: IObserver {
    func update<T>(with value: T) {
        if value is InspirationDetailViewData {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.inspirationDetailView.updateView()
            }
        }
    }
}

extension InspirationDetailViewController: UICollectionViewDelegate {}

extension InspirationDetailViewController: InspirationDetailViewProtocol {

}

// MARK: - Nav Bar Setup

private extension InspirationDetailViewController {
    
    func setupCollectionView() {
        inspirationDetailView.setupCollectionViewDelegate(with: self)
        inspirationDetailView.setupCollectionViewDataSource(with: self)
    }
    
    func setupNavBarButton() {
        navigationItem.title = "HAY"
        let leftButtonImageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
        let leftButtonImage = UIImage(systemName: "chevron.left", withConfiguration: leftButtonImageConfiguration)?.withTintColor(.black)
        
        let leftBarButton = UIBarButtonItem(image: leftButtonImage, style: .done, target: self, action: #selector(backToMainView))
        navigationItem.leftBarButtonItem = leftBarButton
        
        
        let rightButtonImageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
        let rightButtonImage = UIImage(systemName: "square.and.arrow.up", withConfiguration: rightButtonImageConfiguration)
        let rightBarButton = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc
    func backToMainView() {
        navigationController?.popViewController(animated: true)
    }
}
