//
//  MenuResultsController.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 22/09/2020.
//

import Combine

final class MenuResultsController {
    enum Section {
        case items
        case addItems
    }

    enum Row {
        case openItems
        case openLastItem
        case addItem
    }

    @Published var elements: [(Section, [Row])] = [(.items, [.openItems, .openLastItem]), (.addItems, [.addItem])]
}
