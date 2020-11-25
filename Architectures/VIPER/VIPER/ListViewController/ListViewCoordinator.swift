//
//  ListViewCoordinator.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 11/10/2020.
//

import Combine

final class ListViewCoordinator {
    private let storageProviding: StorageProviding

    init(storageProviding: StorageProviding) {
        self.storageProviding = storageProviding
    }

    func present(callbacks: ListViewModel.Callbacks) -> AnyPublisher<ListViewModel, Error> {
        return Future<ListViewModel, Error> {result in
            let resultsController = ListViewResultsController(storageProviding: self.storageProviding)

            result(.success(ListViewModel(callbacks: callbacks, resultsController: resultsController)))
        }
        .eraseToAnyPublisher()
    }
}
