//
//  RowViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//

protocol RowViewModel {
    func cellIdentifier() -> String
}

protocol ViewModelPressible {
    func cellPressed()
}
