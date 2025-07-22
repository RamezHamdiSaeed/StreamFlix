//
//  UseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//
import Foundation
class UseCase<T: Decodable, U: Error> {
    func execute(completion: @escaping (Result<T, U>) -> Void) throws -> Void {
        throw NSError(domain: "Missing Implementation of Use Case", code: 0)
    }
}
