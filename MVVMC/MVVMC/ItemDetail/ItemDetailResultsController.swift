//
//  ItemDetailResultsController.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 23/09/2020.
//

import Combine

final class ItemDetailResultsController {
    enum Section {
        case details
        case actions
    }

    enum Row {
        case detail
        case delete
    }

    @Published var elements: [(Section, [Row])] = []
}
