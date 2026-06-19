//
//  JobDetailViewController.swift
//  RemoteRecruit
//
//  Created by RV on 19/06/26.
//

import UIKit

class JobDetailViewController: UIViewController {

    let jobDetailViewModel = JobDetailViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    
    func initialSetup() {
        jobDetailViewModel.setupNavigationBar(for: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
