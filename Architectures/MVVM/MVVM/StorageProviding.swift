//
//  StorageProviding.swift
//  MVVM
//
//  Created by Jaime Azevedo.
//

import Combine
import Foundation

protocol StorageProviding {
    func fetchAllModels() -> Future<[Model], Error>

    func deleteModel(modelID: String) -> Future<Void, Error>
    func updateModel(identifier: String, content: String, date: Date) -> Future<Model, Error>
}

class DummyModelProvidingService: StorageProviding {
    func fetchAllModels() -> Future<[Model], Error> {
        fatalError()
    }

    func deleteModel(modelID: String) -> Future<Void, Error> {
        fatalError()
    }

    func updateModel(identifier: String, content: String, date: Date) -> Future<Model, Error> {
        fatalError()
    }
}
