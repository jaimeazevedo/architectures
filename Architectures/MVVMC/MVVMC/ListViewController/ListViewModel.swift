//
//  ListViewModel.swift
//  MVVM
//
//  Created by Jaime Azevedo.
//

import Combine

final class ListViewModel {
    struct Callbacks {
        var onEdit: ((Model) -> Void)?
    }

    // MARK: - Properties
    @Published var title: String?
    @Published var elements: [ListViewResultsController.Result] = []

    private var cancellables: Set<AnyCancellable> = []

    private let callbacks: Callbacks
    private let resultsController: ListViewResultsController

    // MARK: - Lifecycle
    deinit {
        cancellables.forEach { $0.cancel() }
    }

    init(callbacks: Callbacks, resultsController: ListViewResultsController) {
        self.callbacks = callbacks
        self.resultsController = resultsController

        resultsController.$elements
            .assign(to: \.elements, on: self)
            .store(in: &cancellables)

        $elements
            .map { "Listing \($0.count) items." }
            .assign(to: \.title, on: self)
            .store(in: &cancellables)
    }

    // MARK: - Public API
    func edit(model: Model) {
        callbacks.onEdit?(model)
    }
}
