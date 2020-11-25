//
//  NavigationControllerModel.swift
//  VIPER
//
//  Created by Jaime Azevedo.
//

struct NavigationControllerModel {
    enum MasterView {
        case list(ListViewModel)

    }

    enum ModalView {
        case editModel(EditModelViewModel)
    }

    let master: [MasterView]
    let modal: ModalView?
}
