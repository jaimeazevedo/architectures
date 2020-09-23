//
//  ItemDetailCollectionViewController.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 23/09/2020.
//

import Combine
import UIKit

final class ItemDetailCollectionViewController: UICollectionViewController {
    // MARK: - Properties
    private var viewModel: ItemDetailViewModel?
    private var observations: [Cancellable] = []

    // MARK: - Lifecycle
    deinit {
        unbind()
    }

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
extension ItemDetailCollectionViewController {
    func open(_ viewModel: ItemDetailViewModel) {
        unbind()

        loadViewIfNeeded()

        navigationItem.title = viewModel.title

        bind(viewModel: viewModel)
    }
}

// MARK: - Bindings
private extension ItemDetailCollectionViewController {
    func bind(viewModel: ItemDetailViewModel) {
        self.viewModel = viewModel

        let dataSource = buildDataSource()

        observations.append(
            viewModel.resultsController.$elements.sink { elements in
                var snapsht =
                    NSDiffableDataSourceSnapshot<ItemDetailResultsController.Section, ItemDetailResultsController.Row>()
                snapsht.appendSections(elements.map { $0.0 })

                elements.forEach { snapsht.appendItems($0.1, toSection: $0.0) }

                dataSource.apply(snapsht, animatingDifferences: true)
            }
        )

        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }

    func unbind() {
        observations.forEach { $0.cancel() }
        observations.removeAll()

        collectionView.delegate = nil
        collectionView.dataSource = nil

        viewModel = nil
    }
}

// MARK: - DataSource
private extension ItemDetailCollectionViewController {
    func buildDataSource(
    ) -> UICollectionViewDiffableDataSource<ItemDetailResultsController.Section, ItemDetailResultsController.Row> {
        return UICollectionViewDiffableDataSource<ItemDetailResultsController.Section, ItemDetailResultsController.Row>(
            collectionView: collectionView
        ) { _, _, _ in
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ItemDetailCollectionViewController {}
