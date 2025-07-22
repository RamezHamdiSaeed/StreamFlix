//
//  BaseCoordinator.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 18/07/2025.
//
import Foundation
import UIKit
protocol BaseCoordinator {
    var presentType: UIModalPresentationStyle {get set}
    var viewController: UIViewController? {get set}
}
