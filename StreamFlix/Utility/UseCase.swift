//
//  UseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//
import Foundation
protocol UseCase {
    func execute(completion: @escaping (Result<Any, Error>) -> Void)
}
