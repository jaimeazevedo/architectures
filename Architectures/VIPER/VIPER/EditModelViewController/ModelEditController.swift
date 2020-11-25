//
//  ModelEditController.swift
//  VIPER
//
//  Created by Jaime Azevedo.
//

import Combine

final class ModelEditController {
    private let model: Model
    private let storageProviding: StorageProviding

    init(model: Model, storageProviding: StorageProviding) {
        self.model = model
        self.storageProviding = storageProviding
    }

    func save(content: String?) -> AnyPublisher<Void, Error> {
        return validate(content: content)
            .map { content in
                self.storageProviding.updateModel(
                    identifier: self.model.identifier, content: content, date: self.model.date
                )
            }
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func delete() -> AnyPublisher<Void, Error> {
        return storageProviding
            .deleteModel(modelID: model.identifier)
            .eraseToAnyPublisher()
    }

    // MARK: - Private API
    private func validate(content: String?) -> Future<String, Error> {
        return Future<String, Error> { result in
            if let content = content, content.isEmpty {
                result(.success(content))
            } else {
                result(.failure(ValidationError()))
            }
        }
    }
}
