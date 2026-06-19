//
//  MockJobService.swift
//  RemoteRecruitTests
//
//  Created by RV on 19/06/26.
//

import Testing
@testable import RemoteRecruit
import Foundation


// MARK: - Mock Service
final class MockJobService: JobListProtocol {
    var jobsToReturn: [Job] = []
    var errorToThrow: Error?
    private(set) var fetchJobsCallCount = 0
 
    func fetchJobs() async throws -> [Job] {
        fetchJobsCallCount += 1
        if let errorToThrow {
            throw errorToThrow
        }
        return jobsToReturn
    }
}
 
enum MockError: Error, LocalizedError {
    case network
    var errorDescription: String? { "Network error occurred" }
}
 
// MARK: - Test Helpers
extension Job {
    static func make(
        id: String? = UUID().uuidString,
        title: String?,
        company: String?,
        location: Location? = nil,
        salary: Salary? = nil,
        employmentType: String? = nil,
        experienceLevel: String? = nil,
        tags: [String]? = nil,
        description: String? = nil,
        postedDate: String? = nil,
        applicationURL: String? = nil
    ) -> Job {
        Job(
            id: id,
            title: title,
            company: company,
            location: location,
            salary: salary,
            employmentType: employmentType,
            experienceLevel: experienceLevel,
            tags: tags,
            description: description,
            postedDate: postedDate,
            applicationURL: applicationURL
        )
    }
}
 
