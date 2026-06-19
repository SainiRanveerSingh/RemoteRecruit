//
//  JobDetailViewController.swift
//  RemoteRecruit
//
//  Created by RV on 19/06/26.
//

import UIKit

class JobDetailViewController: UIViewController {

    let jobDetailViewModel = JobDetailViewControllerViewModel()
    @IBOutlet var labelValues: [UILabel]?
    @IBOutlet weak var viewMain: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    
    func initialSetup() {
        jobDetailViewModel.setupNavigationBar(for: self)
        jobDetailViewModel.loadJobData(labels: labelValues)
        viewMain.cornerRadius = 15.0
        viewMain.borderColor = .gray
        viewMain.borderWidth = 0.8
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
