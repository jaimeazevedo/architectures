//
//  ListViewResultsController.swift
//  MVVM
//
//  Created by Jaime Azevedo on 11/10/2020.
//

import Combine

final class ListViewResultsController {
    typealias Result = (Section, [Row])

    enum Section {
        case main
    }

    enum Row: Hashable, Equatable {
        case item(ListItemViewModel)
    }

    @Published var elements: [(Section, [Row])] = []

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle
    deinit {
        cancellables.forEach { $0.cancel() }
    }

    init(storageProviding: StorageProviding) {
        storageProviding
            .fetchAllModels()
            .sink { error in
                // Deal with error.
            } receiveValue: { [weak self] models in
                let rows = models
                    .sorted { $0.date > $1.date }
                    .map {
                        Row.item(ListItemViewModel(model: $0, title: "\($0.content) @ \($0.date)", detail: "\($0.date)"))
                    }

                self?.elements = [(.main, rows)]
            }
            .store(in: &cancellables)
    }
}
