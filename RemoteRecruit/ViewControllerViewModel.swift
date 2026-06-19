//
//  ViewControllerViewModel.swift
//  RemoteRecruit
//
//  Created by RV on 18/06/26.
//

import Foundation
import UIKit

@MainActor
final class ViewControllerViewModel {
    private let service: JobListProtocol
    var arrayJobList = [Job]()
    var filteredJobs = [Job]()
    
    var reloadData: (() -> Void)?
    var onError: ((String) -> Void)?
    private var currentSearchText: String = ""
    
    init(service: JobListProtocol) {
        self.service = service
    }
    
    func loadJobs() {
        Task {
            do {
                arrayJobList = try await service.fetchJobs()
                if arrayJobList.count > 0 {
                    applyFilter()
                    reloadData?()
                } else {
                    onError?("No Jobs available.")
                }
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
    
    func search(text: String) {
        currentSearchText = text
        applyFilter()
        reloadData?()
    }
    
    private func applyFilter() {
        guard !currentSearchText.isEmpty else {
            filteredJobs = arrayJobList
            return
        }
        filteredJobs = arrayJobList.filter {
            $0.title?.localizedCaseInsensitiveContains(currentSearchText) ?? false
            ||
            $0.company?.localizedCaseInsensitiveContains(currentSearchText) ?? false
        }
    }
    
    func job(at index: Int) -> Job {
        filteredJobs[index]
    }

    func setupNavigationBar(for controller: UIViewController) {
        controller.navigationItem.hidesBackButton = true
        controller.setupNavigationBar(titleText: "Available Jobs")
    }
}
