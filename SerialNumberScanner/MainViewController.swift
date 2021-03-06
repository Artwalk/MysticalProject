//
//  ViewController.swift
//  SerialNumberScanner
//
//  Created by Art on 2/7/18.
//  Copyright © 2018 Art. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var stackView: UIStackView!

    private var submitButtonEnabled: Bool = false {
        didSet {
            submitButton.isEnabled = submitButtonEnabled
            submitButton.backgroundColor = submitButtonEnabled ? #colorLiteral(red: 0.3329455853, green: 0.4274174571, blue: 0.7182831764, alpha: 1) : #colorLiteral(red: 0.3329455853, green: 0.4274174571, blue: 0.7182831764, alpha: 0.5)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        submitButtonEnabled = SNModel.shared.data.count > 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkNewSN()
    }

    @IBAction private func submitButtonTouched(_ sender: UIButton) {
        SNModel.shared.data.forEach {
            SNModel.shared.historyData.insert($0)
        }
        SNModel.shared.data = []

        submitButtonEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.showAlert("假装上传成功了！")

            self?.reloadStackView()
        }
    }

}

extension MainViewController {

    private func reloadStackView() {
        stackView.subviews.forEach { $0.removeFromSuperview() }

        for (i, v) in SNModel.shared.data.enumerated() {
            let dlv = DeviceListView()
            dlv.number = i + 1
            dlv.sn = v
            stackView.addArrangedSubview(dlv)
        }
    }

    private func showAlert(_ title: String) {
        let alertC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertC.addAction(UIAlertAction(title: "好", style: .default, handler: nil))
        present(alertC, animated: true, completion: nil)
    }

    private func checkNewSN() {
        if let sn = SNModel.shared.newSN {
            submitButtonEnabled = true
            if SNModel.shared.historyData.contains(sn) || SNModel.shared.data.contains(sn) {
                showAlert("此设备曾经添加过哦")
            } else if SNModel.shared.data.count >= 5 {
                showAlert("不知为什么一次只能最多添加5台")
            } else {
                SNModel.shared.data.insert(sn)
                reloadStackView()
            }

            SNModel.shared.newSN = nil
        }
    }
}
