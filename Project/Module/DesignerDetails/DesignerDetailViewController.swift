//
//  DesignerDetailViewController.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.08.2024.
//

import UIKit

protocol IDesignerDetailView: AnyObject {}

final class DesignerDetailViewController: UIViewController {
    
    private var designerDetailsView: DesignerDetailsView { return self.view as! DesignerDetailsView }
    private let viewModel: IDesignerDetailsViewModel
    
    // MARK: - Inits
    
    init(viewModel: IDesignerDetailsViewModel) {
        self.viewModel = viewModel
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
    }

}

// MARK: - IDesignerDetailView Protocol

extension DesignerDetailViewController: IDesignerDetailView {}
