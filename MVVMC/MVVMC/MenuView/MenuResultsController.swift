//
//  MenuResultsController.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 22/09/2020.
//

import Combine
import Foundation

final class MenuResultsController {
    struct ViewModel: Hashable, Equatable {
        let title: String
    }

    enum Section {
        case items
        case addItems
    }

    enum Row: Hashable {
        case addItem(ViewModel)
        case openItems(ViewModel)
        case openLastItem(ViewModel)
    }

    @Published var elements: [(Section, [Row])] = []

    init() {
        elements = buildSnapshot()
    }
}

// MARK: - Snapshot build
private extension MenuResultsController {
    func buildSnapshot() -> [(Section, [Row])] {
        return [
            (
                .items,
                [
                    .addItem(ViewModel(title: NSLocalizedString("Open tasks", comment: ""))),
                    .openLastItem(ViewModel(title: NSLocalizedString("Open last task", comment: "")))
                ]
            ),
            (
                .addItems,
                [.addItem(ViewModel(title: NSLocalizedString("Add task", comment: "")))]
            )
        ]
    }
}
