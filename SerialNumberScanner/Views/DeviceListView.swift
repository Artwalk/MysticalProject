//
//  DeviceListView.swift
//  SerialNumberScanner
//
//  Created by Art on 2/9/18.
//  Copyright © 2018 Art. All rights reserved.
//

import UIKit

class DeviceListView: DesignableView {

    var number: Int = 0 {
        didSet {
            UIView.performWithoutAnimation { [weak self] in
                self?.numberButton.setTitle("\(number)", for: .normal)
            }
        }
    }

    var sn: String = "" {
        didSet {
            label.text = sn
        }
    }

    @IBOutlet private weak var numberButton: UIButton!
    @IBOutlet private weak var label: UILabel!
}
