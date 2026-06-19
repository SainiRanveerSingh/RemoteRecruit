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
    
    func loadJobData(labels: [UILabel]?) {
        guard let job = jobData else {
            print("jobData is nil")
            return
        }
        
        guard let dataLabels = labels else
        { return }
        
        for label in dataLabels {
            let tag = label.tag
            
            switch tag {
            case 1001: //Job Posted On
                label.text = job.postedDate ?? "—"
            case 1002: //Company Name
                label.text = job.company ?? "—"
            case 1003: //Role
                label.text = job.title ?? "—"
            case 1004: //Location
                label.text = "\(job.location?.city ?? ""), \(job.location?.country ?? "")"
            case 1005: //Salary Range
                label.text = "\(job.salary?.currency ?? "INR") \(job.salary?.min ?? 0) to \(job.salary?.max ?? 0)"
            case 1006: //Employement Type
                label.text = job.employmentType ?? "—"
            case 1007: // Experience Level
                label.text = job.experienceLevel ?? "—"
            case 1008: //Description
                label.text = job.description ?? "—"
            default:
                break
            }
        }
    }
    
    func setupNavigationBar(for controller: UIViewController) {
        controller.navigationItem.hidesBackButton = false
        controller.setupNavigationBar(titleText: "Job Details")
    }
    
}
