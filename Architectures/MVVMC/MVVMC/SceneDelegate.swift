//
//  SceneDelegate.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 11/10/2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let navigationController = UINavigationController()

    var cancellables: Set<AnyCancellable> = []
    let storageProviding: StorageProviding = DummyModelProvidingService()

    lazy var listViewCoordinator = ListViewCoordinator(storageProviding: storageProviding)
    lazy var editModelViewCoordinator = EditModelViewCoordinator(storageProviding: storageProviding)

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
        
        let listViewController = ListViewController()

        listViewCoordinator
            .present(callbacks: callbacks)
            .sink { (error) in
                // Present error
            } receiveValue: { viewModel in
                listViewController.open(viewModel: listViewModel)
            }
            .store(in: &cancellables)

        navigationController.setViewControllers([listViewController], animated: false)
    }

    private func showEditModelViewController(model: Model) {
        let callbacks = EditModelViewModel.Callbacks { [weak self] in
            self?.navigationController.dismiss(animated: true, completion: nil)
        }

        let editModelViewController = EditModelViewController()

        editModelViewCoordinator
            .present(model: model, callbacks: callbacks)
            .sink { error in
                // Present error
            } receiveValue: { viewModel in
                editModelViewController.open(viewModel: viewModel)
            }
            .store(in: &cancellables)

        navigationController.present(editModelViewController, animated: true, completion: nil)
    }
}

