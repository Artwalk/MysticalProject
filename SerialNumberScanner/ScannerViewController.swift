//
//  ScannerViewController.swift
//  SerialNumberScanner
//
//  Created by Art on 2/7/18.
//  Copyright © 2018 Art. All rights reserved.
//

import UIKit

class ScannerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func returnButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
