//
//  Coordinator.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import UIKit

protocol ICategoryTableCell: AnyObject {
    func update(with categoryType: String)
    func updateData()
}

final class CategoryTableCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: CategoryTableCell.self)
    }
    
    var id: UUID
    var viewModel: ICategoryViewModel?
    
    // MARK: - Constants for constraints

    private let inset: CGFloat = 16
    private let containerViewTopInset: CGFloat = 44
    private let containerViewTrailingInset: CGFloat = 8
    private let containerViewHeight: CGFloat = Constants.Layout.width
    
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        id = UUID()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CategoryTableCell deinit")
    }
    
    // MARK: - UI Elements
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.Subtitles.largeFont
        label.textColor = .black
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let itemWidth: CGFloat = Constants.Layout.width * 0.6
        let itemHeight: CGFloat = Constants.Layout.width * 0.8
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.register(CategoryProductCollectionCell.self, forCellWithReuseIdentifier: CategoryProductCollectionCell.reuseIdentifier)
        return collection
    }()
    
    func update() {
        viewModel?.setupView(with: self)
        viewModel?.subscribe(observer: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.finish()
    }
}

// MARK: - Cell Protocol

extension CategoryTableCell: ICategoryTableCell {
    func updateData() {
        collectionView.reloadData()
    }
    
    func update(with categoryType: String) {
        headerLabel.text = categoryType
    }
}

// MARK: - CollectionView DataSource

extension CategoryTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel else { return 0 }
        return viewModel.numberOfItemInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryProductCollectionCell.reuseIdentifier, for: indexPath) as? CategoryProductCollectionCell else {
            return UICollectionViewCell()
        }
        
        viewModel.setCurrentProduct(at: indexPath.row)
        if viewModel.likeButtonIsUpdating {
            cell.setupLikeButton(with: viewModel.isFavourite, productId: viewModel.productId)
        } else {
            cell.update(productName: viewModel.productName, price: viewModel.price, image: viewModel.image, isFavourite: viewModel.isFavourite, productId: viewModel.productId)
        }
        if let delegate = viewModel as? ILikeButton {
            cell.setupLikeButtonDelegate(delegate)
        }
        return cell
    }
}

// MARK: - CollectionView Delegate

extension CategoryTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.showDetail(with: indexPath.row)
    }
}

// MARK: - IObserver

extension CategoryTableCell: IObserver {
    func update<T>(with value: T) {
        if value is Products {
            collectionView.reloadData()
        }
    }
}

// MARK: - Setups

private extension CategoryTableCell {
    func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(headerLabel)
        containerView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: containerViewTopInset).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -containerViewTrailingInset).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: containerViewHeight).isActive = true
        
        headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: inset).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -inset).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -inset).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
}
