//
//  SoldDeviceTableViewController.swift
//  SerialNumberScanner
//
//  Created by Art on 2/7/18.
//  Copyright © 2018 Art. All rights reserved.
//

import UIKit

extension Date {
    func toString(_ formatter: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = formatter
        dateFormatter.locale = Locale.current

        return dateFormatter.string(from: self)
    }
}

class SoldDeviceTableViewController: UITableViewController {

    var dataSource = Array(SNModel.shared.historyData)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "Background"))
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Date().toString("yyyy.MM.dd")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SoldDeviceTableViewCell else { return UITableViewCell() }

        cell.label?.text = dataSource[indexPath.row]
        return cell
    }

}
