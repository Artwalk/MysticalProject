//
//  ViewController.swift
//  SerialNumberScanner
//
//  Created by Art on 2/7/18.
//  Copyright © 2018 Art. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkNewSN()
    }

}

extension MainViewController {
    private func showDuplicateAlert() {
        let alertC = UIAlertController(title: "你已经添加过此设备了哦", message: "", preferredStyle: .alert)
        alertC.addAction(UIAlertAction(title: "知道了", style: .default, handler: nil))
        present(alertC, animated: true, completion: nil)
    }

    private func checkNewSN() {
        if let sn = SNModel.shared.newSN {
            if SNModel.shared.data.contains(sn) {
                showDuplicateAlert()
            } else {
                SNModel.shared.data.insert(sn)
                
            }
            SNModel.shared.newSN = nil
        }
    }
}
