//
//  EditModelViewModel.swift
//  MVVM
//
//  Created by Jaime Azevedo.
//

import Combine

final class EditModelViewModel {
    struct Callbacks {
        var onClose: (() -> Void)?
    }

    // MARK: - Properties
    @Published var content: String?
    @Published var elements: [EditModelResultsController.Result] = []

    private var cancellables: Set<AnyCancellable> = []

    private let model: Model
    private let callbacks: Callbacks
    private let modelController: ModelEditController
    private let resultsController: EditModelResultsController

    // MARK: - Lifecycle
    deinit {
        cancellables.forEach { $0.cancel() }
    }

    init(model: Model, callbacks: Callbacks, modelController: ModelEditController) {
        self.model = model
        self.callbacks = callbacks
        self.modelController = modelController
        self.resultsController = EditModelResultsController()

        self.content = model.content

        resultsController.$elements
            .assign(to: \.elements, on: self)
            .store(in: &cancellables)
    }

    // MARK: - Public API
    func save() -> AnyPublisher<Void, Error> {
        return modelController
            .save(content: content)
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.callbacks.onClose?()
            })
            .eraseToAnyPublisher()
    }

    func delete() -> AnyPublisher<Void, Error> {
        return modelController
            .delete()
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.callbacks.onClose?()
            })
            .eraseToAnyPublisher()
    }
}
