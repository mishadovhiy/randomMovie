//
//  UITableView.swift
//  MovieList
//
//  Created by Misha Dovhiy on 05.05.2022.
//

import UIKit

extension SideBarVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count + self.sectionsBeforeData
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarTitleCell", for: indexPath) as! SideBarTitleCell
            cell.mainLabel.text = "Filter"
            return cell
        } else {
            let section = indexPath.section - sectionsBeforeData
            if let sliderData = tableData[section].cells as? SliderCellData {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarSliderCell", for: indexPath) as! SideBarSliderCell
                cell.range = .init(view: cell.rangeHolderView, range: sliderData.range, newPosition: sliderData.newPosition)
                return cell
            } else {
                if let collections = tableData[section].cells as? CollectionCellData {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarCollectionCell", for: indexPath) as! SideBarCollectionCell
                    cell.data = collections.collectionData
                    cell.valueSelected = collections.selected
                    return cell
                } else {
                    return UITableViewCell()
                }
            }
        }
        

        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section == 0 ? 0 : (indexPath.section - sectionsBeforeData)
        if indexPath.section != 0 {
            if let data = tableData[section].cells as? CollectionCellData {
                let numOfSections = data.collectionData.count / 3
                let result = numOfSections * 50
                return CGFloat(result)
                
            }
        }
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section != 0 ? 38 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section != 0 {
            let sectionn = section == 0 ? 0 : (section - sectionsBeforeData)
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarHeaderCell") as! SideBarHeaderCell
            cell.mainTitleLabel.text = tableData[sectionn].title
            return cell.contentView
        } else {
            return nil
        }
        
    }
}
