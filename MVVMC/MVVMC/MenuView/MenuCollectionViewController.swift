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
        self.viewModel = viewModel

        navigationItem.title = viewModel.title
    }
}
