//
//  ListViewController.swift
//  MVVM
//
//  Created by Jaime Azevedo.
//

import Combine
import UIKit

final class ListViewController: UICollectionViewController {
    private var viewModel: ListViewModel?
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle
    deinit {
        cancellables.forEach { $0.cancel() }
    }

    init() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)

        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func open(viewModel: ListViewModel) {
        self.viewModel = viewModel

        let dataSource = buildDataSource()

        viewModel.$title
            .assign(to: \.title, on: navigationItem)
            .store(in: &cancellables)

        viewModel.$elements
            .sink { elements in
                var snapshot = NSDiffableDataSourceSnapshot<ListViewResultsController.Section, ListViewResultsController.Row>()
                snapshot.appendSections(elements.map { $0.0 })

                elements.forEach { snapshot.appendItems($0.1, toSection: $0.0) }

                dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)

        collectionView.dataSource = dataSource
    }

    // MARK: - Private API
    private func buildDataSource() -> UICollectionViewDiffableDataSource<ListViewResultsController.Section, ListViewResultsController.Row> {
        let cellRegistration = UICollectionView
            .CellRegistration<UICollectionViewListCell, ListItemViewModel> { cell, _, viewModel in
                var content = UIListContentConfiguration.cell()
                content.text = viewModel.title
                content.secondaryText = viewModel.detail

                cell.contentConfiguration = content
                cell.accessories = [.disclosureIndicator()]
            }

        return UICollectionViewDiffableDataSource<ListViewResultsController.Section, ListViewResultsController.Row>(
            collectionView: collectionView
        ) { collectionView, indexPath, object in
            switch object {
            case let .item(viewModel):
                return collectionView
                    .dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: viewModel)
            }
        }
    }

    private func edit(model: Model) {
        viewModel?.edit(model: model)
    }

    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }

        switch viewModel.elements[indexPath.section].1[indexPath.row] {
        case let .item(listItemViewModel):
            edit(model: listItemViewModel.model)
        }
    }
}
