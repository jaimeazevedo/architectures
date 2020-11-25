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
    private let storageProviding: StorageProviding
    private let resultsController: EditModelResultsController

    // MARK: - Lifecycle
    deinit {
        cancellables.forEach { $0.cancel() }
    }

    init(model: Model, callbacks: Callbacks, storageProviding: StorageProviding) {
        self.model = model
        self.callbacks = callbacks
        self.storageProviding = storageProviding
        self.resultsController = EditModelResultsController()

        self.content = model.content

        resultsController.$elements
            .assign(to: \.elements, on: self)
            .store(in: &cancellables)
    }

    // MARK: - Public API
    func save() -> AnyPublisher<Void, Error> {
        return validate(content: content)
            .map { content in
                self.storageProviding.updateModel(
                    identifier: self.model.identifier, content: content, date: self.model.date
                )
            }
            .map { _ in }
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.callbacks.onClose?()
            })
            .eraseToAnyPublisher()
    }

    func delete() -> AnyPublisher<Void, Error> {
        return storageProviding
            .deleteModel(modelID: model.identifier)
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.callbacks.onClose?()
            })
            .eraseToAnyPublisher()
    }

    // MARK: - Private API
    private func validate(content: String?) -> Future<String, Error> {
        return Future<String, Error> { result in
            if let content = self.content, content.isEmpty {
                result(.success(content))
            } else {
                result(.failure(ValidationError()))
            }
        }
    }
}
