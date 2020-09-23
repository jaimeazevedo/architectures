//
//  ItemsCollectionViewController.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 22/09/2020.
//

import Combine
import UIKit

final class ItemsCollectionViewController: UICollectionViewController {
    // MARK: - Properties
    private var viewModel: ItemsViewModel?
    private var observations: [Cancellable] = []

    // MARK: - Lifecycle
    deinit {
        unbind()
    }

    init() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)

        super.init(collectionViewLayout: layout)
    }

    @available(*, unavailable, message: "Please use init() instead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Views
    private lazy var sortByDateAction: UIAction = {
        return UIAction(
            title: NSLocalizedString("Sort by date", comment: ""),
            image: nil,
            identifier: nil,
            discoverabilityTitle: NSLocalizedString("Sort by date", comment: ""),
            attributes: [],
            state: .off
        ) { [weak self] _ in
            self?.viewModel?.resultsController.sortOrder = .date
        }
    }()

    private lazy var sortByNameAction: UIAction = {
        return UIAction(
            title: NSLocalizedString("Sort by name", comment: ""),
            image: nil,
            identifier: nil,
            discoverabilityTitle: NSLocalizedString("Sort by name", comment: ""),
            attributes: [],
            state: .off
        ) { [weak self] _ in
            self?.viewModel?.resultsController.sortOrder = .name
        }
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        return UISegmentedControl(frame: .zero, actions: [sortByDateAction, sortByNameAction])
    }()
}

// MARK: - Extension View Lifecycle
extension ItemsCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = segmentedControl
    }
}

// MARK: - Public API
extension ItemsCollectionViewController {
    func open(_ viewModel: ItemsViewModel) {
        loadViewIfNeeded()

        unbind()

        navigationItem.title = viewModel.title

        bind(viewModel: viewModel)
    }
}

// MARK: - Bindings
private extension ItemsCollectionViewController {
    func bind(viewModel: ItemsViewModel) {
        self.viewModel = viewModel

        let dataSource = buildDataSource()

        observations.append(
            viewModel.resultsController.$elements.sink { elements in
                var snapsht = NSDiffableDataSourceSnapshot<ItemsResultsController.Section, ItemsResultsController.Row>()
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
private extension ItemsCollectionViewController {
    func buildDataSource(
    ) -> UICollectionViewDiffableDataSource<ItemsResultsController.Section, ItemsResultsController.Row> {
        let cellRegistration = UICollectionView
            .CellRegistration<UICollectionViewListCell, ItemsResultsController.ViewModel> { cell, _, viewModel in
                var content = UIListContentConfiguration.cell()
                content.text = viewModel.content
                content.secondaryText = viewModel.formattedDate

                cell.contentConfiguration = content
                cell.accessories = [.disclosureIndicator()]
            }

        return UICollectionViewDiffableDataSource<ItemsResultsController.Section, ItemsResultsController.Row>(
            collectionView: collectionView
        ) { collectionView, indexPath, object in
            switch object {
            case let .item(viewModel):
                return collectionView
                    .dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: viewModel)
            }
        }
    }
}

// MARK: - CollectionViewDelegate
extension ItemsCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let viewModel = viewModel else {
            return
        }

        switch viewModel.resultsController.object(at: indexPath) {
        case .item:
            let resultsController = ItemDetailResultsController()
            let viewModel = ItemDetailViewModel(resultsController: resultsController)
            let viewController = ItemDetailCollectionViewController()
            viewController.open(viewModel)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
