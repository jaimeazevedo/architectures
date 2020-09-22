//
//  MenuViewModel.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 22/09/2020.
//

final class MenuViewModel {
    let title = "Welcome"
    let resultsController: MenuResultsController

    init(resultsController: MenuResultsController) {
        self.resultsController = resultsController
    }
}
