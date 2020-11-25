//
//  SceneDelegate.swift
//  MVVM
//
//  Created by Jaime Azevedo.
//

import Combine
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let storageProviding: StorageProviding = DummyModelProvidingService()

    private var cancellables: Set<AnyCancellable> = []
    let navigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController

        showModelListViewController()
    }

    // MARK: - Private API
    private func showModelListViewController() {
        let callbacks = ListViewModel.Callbacks { [weak self] model in
            self?.showEditModelViewController(model: model)
        }

        let listViewModel = ListViewModel(
            callbacks: callbacks,
            resultsController: ListViewResultsController(storageProviding: storageProviding)
        )

        let listViewController = ListViewController()
        listViewController.open(viewModel: listViewModel)

        navigationController.setViewControllers([listViewController], animated: false)
    }

    private func showEditModelViewController(model: Model) {
        let callbacks = EditModelViewModel.Callbacks { [weak self] in
            self?.navigationController.dismiss(animated: true, completion: nil)
        }

        let editModelViewModel = EditModelViewModel(model: model, callbacks: callbacks, storageProviding: storageProviding)

        let editModelViewController = EditModelViewController()
        editModelViewController.open(viewModel: editModelViewModel)

        navigationController.present(editModelViewController, animated: true, completion: nil)
    }
}

