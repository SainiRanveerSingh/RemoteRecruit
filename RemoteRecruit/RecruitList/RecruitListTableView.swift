//
//  RecruitListTableView.swift
//  RemoteRecruit
//
//  Created by RV on 18/06/26.
//

import Foundation
import UIKit

class RecruitListTableView: UITableView {
    
    var viewControllerViewModel: ViewControllerViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ viewModel: ViewControllerViewModel) {
        self.viewControllerViewModel = viewModel
        dataSource = self
        delegate = self
        let nib = UINib.init(nibName: "RecruitListTableViewCell", bundle: nil)
        self.register(nib, forCellReuseIdentifier: "RecruitListTableViewCell")
        self.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.estimatedRowHeight = 350.0
        if self.tableFooterView != nil {
            self.tableFooterView = UIView()
        }
    }
}

extension RecruitListTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewControllerViewModel.filteredJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(indexPath : indexPath)
    }
    
    func cell(indexPath : IndexPath) -> RecruitListTableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "RecruitListTableViewCell", for: indexPath) as! RecruitListTableViewCell
        cell.configureCell(indexPath: indexPath, job: self.viewControllerViewModel.arrayJobList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        
        //didSelect?(self.viewModel.arrayMyCoursesList[indexPath.row], indexPath.row, .simple, bgColor)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func displayData() {
        self.reloadData()
    }
    
    
}
