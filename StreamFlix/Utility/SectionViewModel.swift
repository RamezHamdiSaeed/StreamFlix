//
//  SectionViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//
import UIKit

struct SectionViewModel {
    let sectionModel: SectionModel
    let rowViewModels: [RowViewModel]
}

struct SectionModel {
    var headerTitle: String?
    var headerHeight: CGFloat?
    var isEnabled: Bool = true
}
