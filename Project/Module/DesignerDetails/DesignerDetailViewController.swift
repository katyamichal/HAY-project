//
//  DesignerDetailViewController.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import UIKit

enum DesignerDetailsSection: Int, CaseIterable {
    case designerInfo
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
        case .designerInfo:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = DesignerDetailsSection.allCases[indexPath.section]
        switch section {
        case .designerInfo:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesignerInfoCollectionCell.reuseIndentifier, for: indexPath) as? DesignerInfoCollectionCell else {
                return UICollectionViewCell()
            }
            cell.update(designerName: viewModel.designerName, designerImage: viewModel.designerImage, designerBio: viewModel.designerDescription)
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
