//
//  EditModelViewCoordinator.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 11/10/2020.
//

import Combine

final class EditModelViewCoordinator {
    private let storageProviding: StorageProviding

    init(storageProviding: StorageProviding) {
        self.storageProviding = storageProviding
    }

    func present(model: Model, callbacks: EditModelViewModel.Callbacks) -> AnyPublisher<EditModelViewModel, Error> {
        return Future<EditModelViewModel, Error> { result in
            result(.success(EditModelViewModel(model: model, callbacks: callbacks, storageProviding: storageProviding)))
        }
    }
}
