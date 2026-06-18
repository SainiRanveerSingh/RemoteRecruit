//
//  ViewController.swift
//  RemoteRecruit
//
//  Created by RV on 18/06/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableJobList: RecruitListTableView!
    @IBOutlet weak var labelLoading: UILabel!
    let viewModel = ViewControllerViewModel()
    //Pull to Refresh Code
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    func initialSetup() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableJobList.addSubview(refreshControl)
        
        tableJobList.configure(viewModel)
        viewModel.loadJobs()
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh
        viewModel.loadJobs()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            self.tableJobList.displayData()
            self.refreshControl.endRefreshing()
            if viewModel.arrayJobList.count > 0 {
                self.labelLoading.isHidden = true
            } else { self.labelLoading.isHidden = false }
         }
    }


}

