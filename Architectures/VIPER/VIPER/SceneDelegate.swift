//
//  SceneDelegate.swift
//  VIPER
//
//  Created by Jaime Azevedo on 11/10/2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let storageProviding: StorageProviding = DummyModelProvidingService()

    let navigationController = MainNavigationController()
    lazy var mainRouter = MainRouter(storageProviding: storageProviding)

    var cancellables: Set<AnyCancellable> = []

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController

        mainRouter
            .navigate(to: .listView)
            .sink { error in
                // Display error
            } receiveValue: { [weak self] navigationViewModel in
                self?.navigationController.open(viewModel: navigationViewModel)
            }
            .store(in: &cancellables)
    }
}

