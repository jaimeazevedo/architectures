//
//  ItemsViewModel.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 22/09/2020.
//

import Foundation

final class ItemsViewModel {
    let title = NSLocalizedString("Tasks", comment: "")
    let resultsController: ItemsResultsController

    init(resultsController: ItemsResultsController) {
        self.resultsController = resultsController
    }
}
