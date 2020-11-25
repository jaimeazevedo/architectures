//
//  MainNavigationController.swift
//  VIPER
//
//  Created by Jaime Azevedo.
//

import UIKit

final class MainNavigationController: UINavigationController {
    private lazy var listViewController = ListViewController()
    private lazy var editModelViewController = EditModelViewController()

    // MARK: - Public API
    func open(viewModel: NavigationControllerModel) {
        setViewControllers(masterViews(viewModel: viewModel), animated: true)

        guard let modal = modalViews(viewModel: viewModel) else {
            return
        }

        present(modal, animated: true, completion: nil)
    }

    // MARK: - Private API
    private func masterViews(viewModel: NavigationControllerModel) -> [UIViewController] {
        return viewModel.master
            .map {
                switch $0 {
                case .list(listViewModel):
                    listViewController.open(viewModel: viewModel)

                    return listViewController
                }
            }
    }

    private func modalViews(viewModel: NavigationControllerModel) -> UIViewController? {
        guard let modal = viewModel.modal else {
            return nil
        }

        switch modal {
        case let .editModel(editModelViewModel):
            editModelViewController.open(viewModel: viewModel)

            return editModelViewController
        }
    }
}
