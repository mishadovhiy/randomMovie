//
//  UITableViewExtension.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return tableData.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            let data = tableData[indexPath.row]
            cell.nameLabel.text = data.description
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaggingCell", for: indexPath) as! PaggingCell
            cell.valueSteppedAction = pageChanged(_:)
            cell.pageLabel.text = "\(page)"
            cell.pageStepper.value = Double("\(page)") ?? 0
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}
