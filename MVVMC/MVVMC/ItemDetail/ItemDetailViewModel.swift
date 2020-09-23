//
//  ItemDetailViewModel.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 23/09/2020.
//

import Foundation

final class ItemDetailViewModel {
    let title = NSLocalizedString("Task details", comment: "")
    let resultsController: ItemDetailResultsController

    init(resultsController: ItemDetailResultsController) {
        self.resultsController = resultsController
    }
}
