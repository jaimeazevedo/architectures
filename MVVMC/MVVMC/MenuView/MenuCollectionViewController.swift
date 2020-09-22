//
//  MenuCollectionViewController.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 22/09/2020.
//

import UIKit

final class MenuCollectionViewController: UICollectionViewController {
    private var viewModel: MenuViewModel?

    init() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)

        super.init(collectionViewLayout: layout)
    }

    @available(*, unavailable, message: "Please use init() instead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public API
extension MenuCollectionViewController {
    func open(_ viewModel: MenuViewModel) {
        loadViewIfNeeded()

        unbind()

        navigationItem.title = viewModel.title

        bind(viewModel: viewModel)
    }
}

// MARK: - Bindings
private extension MenuCollectionViewController {
    func bind(viewModel: MenuViewModel) {
        self.viewModel = viewModel
    }

    func unbind() {
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
}
