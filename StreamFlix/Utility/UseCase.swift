//
//  UseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//
import Foundation
class UseCase<T: Decodable> {
    func execute(completion: @escaping (Result<T, APIError>) -> Void) throws -> Void {
        throw NSError(domain: "Missing Implementation of Use Case", code: 0)
    }
}
