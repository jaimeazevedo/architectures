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
                    .openItems(ViewModel(title: NSLocalizedString("Open tasks", comment: ""))),
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

// MARK: - TypedResultsController
extension MenuResultsController {
    func object(at indexPath: IndexPath) -> Row {
        return elements[indexPath.section].1[indexPath.row]
    }

    func indexPath(for object: Row) -> IndexPath? {
        fatalError("Not implemented.")
    }
}
