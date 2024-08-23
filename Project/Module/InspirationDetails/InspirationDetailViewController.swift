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
    
    // MARK: - Inits
    
    init(viewModel: InspirationDetailViewModelProtocol) {
        self.viewModel = viewModel
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

extension InspirationDetailViewController: InspirationDetailViewProtocol {}

// MARK: - Nav Bar Setup

private extension InspirationDetailViewController {
    
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
