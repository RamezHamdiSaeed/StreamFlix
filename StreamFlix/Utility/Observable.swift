//
//  Observable.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 17/07/2025.
//
import Foundation

class Observable<T> {

    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }

    private var valueChanged: ((T) -> Void)?

    init(value: T) {
        self.value = value
    }

    func addObserver(isFiringNow: Bool = false, _ onChange: @escaping (T) -> Void) {
        self.valueChanged = onChange
        if isFiringNow {
            onChange(value)
        }
    }

    func removeObserver() {
        self.valueChanged = nil
    }
}
