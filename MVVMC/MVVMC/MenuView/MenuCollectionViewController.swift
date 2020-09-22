//
//  MenuCollectionViewController.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 22/09/2020.
//

import Combine
import UIKit

final class MenuCollectionViewController: UICollectionViewController {
    // MARK: - Properties
    private var viewModel: MenuViewModel?
    private var observations: [Cancellable] = []

    // MARK: - Lifecycle
    deinit {
        unbind()
    }

    init() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
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

        let dataSource = buildDataSource()

        observations.append(
            viewModel.resultsController.$elements.sink { elements in
                var snapshot = NSDiffableDataSourceSnapshot<MenuResultsController.Section, MenuResultsController.Row>()
                snapshot.appendSections(elements.map { $0.0 })

                elements.forEach { snapshot.appendItems($0.1, toSection: $0.0) }

                dataSource.apply(snapshot, animatingDifferences: true)
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
private extension MenuCollectionViewController {
    func buildDataSource(
    ) -> UICollectionViewDiffableDataSource<MenuResultsController.Section, MenuResultsController.Row> {
        let disclosureCellRegistration = UICollectionView
            .CellRegistration<UICollectionViewListCell, MenuResultsController.ViewModel> { cell, _, viewModel in
            var content = UIListContentConfiguration.cell()
            content.text = viewModel.title

            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }

        let plainCellRegistration = UICollectionView
            .CellRegistration<UICollectionViewListCell, MenuResultsController.ViewModel> { cell, _, viewModel in
            var content = UIListContentConfiguration.cell()
            content.text = viewModel.title

            cell.contentConfiguration = content
        }

        return UICollectionViewDiffableDataSource<MenuResultsController.Section, MenuResultsController.Row>(
            collectionView: collectionView
        ) { collectionView, indexPath, object in
            switch object {
            case let .openItems(viewModel), let .openLastItem(viewModel):
                return collectionView
                    .dequeueConfiguredReusableCell(using: disclosureCellRegistration, for: indexPath, item: viewModel)

            case let .addItem(viewModel):
                return collectionView
                    .dequeueConfiguredReusableCell(using: plainCellRegistration, for: indexPath, item: viewModel)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MenuCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let viewModel = viewModel else {
            return
        }

        switch viewModel.resultsController.object(at: indexPath) {
        case .addItem:
            break

        case .openItems:
            let resultsController = ItemsResultsController()
            let viewModel = ItemsViewModel(resultsController: resultsController)
            let viewController = ItemsCollectionViewController()
            viewController.open(viewModel)

            navigationController?.pushViewController(viewController, animated: true)

        case .openLastItem:
            break
        }
    }
}
