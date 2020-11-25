//
//  MainRouter.swift
//  VIPER
//
//  Created by Jaime Azevedo on 11/10/2020.
//

import Combine
import UIKit

final class MainRouter {
    struct Callbacks {
        var onPresent: ((NavigationControllerModel) -> Void)?
    }

    enum Destination {
        case listView
        case editView(Model)
    }

    private let callbacks: Callbacks
    private let storageProviding: StorageProviding
    private let listViewCoordinator: ListViewCoordinator
    private let editModelViewCoordinator: EditModelViewCoordinator

    private var cancellables: Set<AnyCancellable> = []

    init(callbacks: Callbacks, storageProviding: StorageProviding) {
        self.callbacks = callbacks
        self.storageProviding = storageProviding

        listViewCoordinator = ListViewCoordinator(storageProviding: storageProviding)
        editModelViewCoordinator = EditModelViewCoordinator(storageProviding: storageProviding)
    }

    // MARK: - Public API
    func navigate(to destination: Destination) {
        switch destination {
        case .listView:
            listView()
                .map { listViewModel in
                    return NavigationControllerModel(master: [.list(listViewModel)], modal: nil)
                }
                .sink { completion in
                    // Present error/cleanup.
                } receiveValue: { [weak self] navigationModel in
                    self?.callbacks.onPresent?(navigationModel)
                }
                .store(in: &cancellables)

        case let .editView(model):
            listView()
                .combineLatest(editModelView(model: model))
                .map { listViewModel, editModelViewModel in
                    return NavigationControllerModel(master: [.list(listViewModel)], modal: .editModel(editModelViewModel))
                }
                .sink { completion in
                    // Present error/cleanup.
                } receiveValue: { [weak self] navigationModel in
                    self?.callbacks.onPresent?(navigationModel)
                }
                .store(in: &cancellables)
        }
    }

    // MARK: - Private API
    private func listView() -> AnyPublisher<ListViewModel, Error> {
        let callbacks = ListViewModel.Callbacks { [weak self] model in
            self?.navigate(to: .editView(model))
        }

        return listViewCoordinator
            .present(callbacks: callbacks)  
            .eraseToAnyPublisher()
    }

    private func editModelView(model: Model) -> AnyPublisher<EditModelViewModel, Error> {
        let callbacks = EditModelViewModel.Callbacks { [weak self] in
            self?.navigate(to: .listView)
        }

        return editModelViewCoordinator
            .present(model: model, callbacks: callbacks)
            .eraseToAnyPublisher()
    }
}
