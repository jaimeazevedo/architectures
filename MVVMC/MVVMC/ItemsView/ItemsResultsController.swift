//
//  ItemsResultsController.swift
//  MVVMC
//
//  Created by Jaime Azevedo on 22/09/2020.
//

import Combine
import Foundation

final class ItemsResultsController {
    struct ViewModel: Hashable, Equatable {
        let content: String
        let formattedDate: String
    }

    enum Section {
        case items
    }

    enum Row: Hashable {
        case item(ViewModel)
    }

    enum SortOrder {
        case name
        case date
    }

    private let dateFormatter: DateFormatter

    @Published var sortOrder: SortOrder = .date {
        didSet {
            performFetch(sortOrder: sortOrder)
        }
    }

    @Published private(set) var elements: [(Section, [Row])] = []

    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .long

        performFetch(sortOrder: sortOrder)
    }

    // Mockup content
    private var fetchedElements: [(String, Date)] = {
        return [
            ("Buy eggs", Date()),
            ("Feed the cat", Date(timeIntervalSinceNow: 42)),
            ("Water plants", Date(timeIntervalSinceNow: -21))
        ]
    }()
}

private extension ItemsResultsController {
    func performFetch(sortOrder: SortOrder) {
        elements = buildSnapshot(sortOrder: sortOrder)
    }
}

private extension ItemsResultsController {
    func buildSnapshot(sortOrder: SortOrder) -> [(Section, [Row])] {
        let sortedItems = sortOrder == .date
            ? fetchedElements.sorted(by: { $0.1.compare($1.1) == .orderedAscending })
            : fetchedElements.sorted(by: { $0.0.compare($1.0) == .orderedAscending })

        let sortedViewModels: [Row] = sortedItems
            .map { ViewModel(content: $0.0, formattedDate: dateFormatter.string(from: $0.1)) }
            .map { .item($0) }

        return [(.items, sortedViewModels)]
    }
}
