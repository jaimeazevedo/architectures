//
//  EditModelViewController.swift
//  MVVM
//
//  Created by Jaime Azevedo.
//

import Combine
import UIKit

final class EditModelViewController: UICollectionViewController {
    private var viewModel: EditModelViewModel?
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle
    deinit {
        cancellables.forEach { $0.cancel() }
    }

    init() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)

        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func open(viewModel: EditModelViewModel) {
        self.viewModel = viewModel

        let dataSource = buildDataSource()

        viewModel.$elements
            .sink { elements in
                var snapshot = NSDiffableDataSourceSnapshot<EditModelResultsController.Section, EditModelResultsController.Row>()
                snapshot.appendSections(elements.map { $0.0 })

                elements.forEach { snapshot.appendItems($0.1, toSection: $0.0) }

                dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)

        collectionView.dataSource = dataSource
    }

    // MARK: - Private API
    private func buildDataSource() -> UICollectionViewDiffableDataSource<EditModelResultsController.Section, EditModelResultsController.Row> {
        fatalError()
    }

    private func delete() {
        viewModel?
            .delete()
            .sink(
                receiveCompletion: { error in
                    // Handle error
                },
                receiveValue: {
                    // Nothing to do with result
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }

        switch viewModel.elements[indexPath.section].1[indexPath.row] {
        case .content:
            break

        case .delete:
            delete()
        }
    }
}
