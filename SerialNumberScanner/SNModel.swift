//
//  ViewModel.swift
//  SerialNumberScanner
//
//  Created by Art on 2/8/18.
//  Copyright © 2018 Art. All rights reserved.
//

import Foundation

class SNModel {

    static let shared = SNModel()
    private init() {}

    var data = Set<String>()
    var newSN: String?

    var historyData = Set<String>()
}
