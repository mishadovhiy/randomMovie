//
//  UITableView.swift
//  MovieList
//
//  Created by Misha Dovhiy on 05.05.2022.
//

import UIKit

extension SideBar: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let sliderData = tableData[indexPath.section].cells as? SliderCellData {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarSliderCell", for: indexPath) as! SideBarSliderCell
            cell.range = .init(view: cell.rangeHolderView, range: sliderData.range, newPosition: sliderData.newPosition)
            return cell
        } else {
            if let collections = tableData[indexPath.section].cells as? CollectionCellData {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarCollectionCell", for: indexPath) as! SideBarCollectionCell
                return cell
            } else {
                return UITableViewCell()
            }
        }

        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       /* if tableData[indexPath.section].section[indexPath.row].name != "" {
            let segue = tableData[indexPath.section].section[indexPath.row].segue
            if segue != "" {
                DispatchQueue.main.async {
                    ViewController.shared?.performSegue(withIdentifier: segue, sender: self)
                }
            } else {
                if let action = tableData[indexPath.section].section[indexPath.row].selectAction {
                    action()
                }
            }
        }
        tableView.reloadData()
        */
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarHeaderCell") as! SideBarHeaderCell
        cell.mainTitleLabel.text = tableData[section].title
        return cell.contentView
    }
}
