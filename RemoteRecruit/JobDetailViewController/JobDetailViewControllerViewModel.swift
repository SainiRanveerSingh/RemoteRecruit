//
//  JobDetailViewControllerViewModel.swift
//  RemoteRecruit
//
//  Created by RV on 19/06/26.
//

import Foundation
import UIKit

final class JobDetailViewControllerViewModel {
    var jobData: Job?
    
    func loadJobData() {
        guard let job = jobData else {
            print("jobData is nil")
            return
        }
    }
    
    func setupNavigationBar(for controller: UIViewController) {
        controller.navigationItem.hidesBackButton = false
        controller.setupNavigationBar(titleText: "Job Details")
    }
}
