//
//  ViewControllerViewModel.swift
//  RemoteRecruit
//
//  Created by RV on 18/06/26.
//

import Foundation

@MainActor
final class ViewControllerViewModel {
    private let service: JobListProtocol
    var arrayJobList = [Job]()
    var filteredJobs = [Job]()
    
    var reloadData: (() -> Void)?
    var onError: ((String) -> Void)?

    init(service: JobListProtocol = JobListService()) {
        self.service = service
    }
    
    func loadJobs() {
        Task {
            do {
                arrayJobList = try await service.fetchJobs()
                filteredJobs = arrayJobList
                reloadData?()
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
    
    func search(text: String) {
            guard !text.isEmpty else {
                filteredJobs = arrayJobList
                reloadData?()
                return
            }
            filteredJobs = arrayJobList.filter {
                $0.title?.localizedCaseInsensitiveContains(text) ?? false
                ||
                $0.company?.localizedCaseInsensitiveContains(text) ?? false
            }
            reloadData?()
        }

        func job(at index: Int) -> Job {
            filteredJobs[index]
        }

        var count: Int {
            filteredJobs.count
        }
    
}
