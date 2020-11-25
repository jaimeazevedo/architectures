//
//  EditModelResultsController.swift
//  MVVM
//
//  Created by Jaime Azevedo.
//

import Combine

final class EditModelResultsController {
    typealias Result = (Section, [Row])

    enum Section {
        case editableProperties
        case delete
    }

    enum Row {
        case content
        case delete
    }

    @Published var elements: [Result] = [(.editableProperties, [.content]), (.delete, [.delete])]
}
