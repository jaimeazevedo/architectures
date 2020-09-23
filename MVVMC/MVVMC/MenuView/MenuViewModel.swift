//
//  MenuViewModel.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 22/09/2020.
//

import Foundation

final class MenuViewModel {
    let title = NSLocalizedString("Welcome", comment: "")
    let resultsController: MenuResultsController

    init(resultsController: MenuResultsController) {
        self.resultsController = resultsController
    }
}
