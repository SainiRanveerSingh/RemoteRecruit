//
//  JobsListResponse.swift
//  RemoteRecruit
//
//  Created by RV on 18/06/26.
//

import Foundation
// MARK: - JobsListResponse
struct JobsListResponse: Codable {
    let data: DataValueClass?
    let status: Bool?
    let message: String?
}

// MARK: - DataValueClass
struct DataValueClass: Codable {
    let listDetails: ListDetails?
    let jobs: [Job]?
}

// MARK: - Job
struct Job: Codable {
    let id, title, company: String?
    let location: Location?
    let salary: Salary?
    let employmentType: String?
    let experienceLevel: String?
    let tags: [String]?
    let description, postedDate: String?
    let applicationURL: String?

    enum CodingKeys: String, CodingKey {
        case id, title, company, location, salary
        case employmentType = "employment_type"
        case experienceLevel = "experience_level"
        case tags, description
        case postedDate = "posted_date"
        case applicationURL = "application_url"
    }
}

// MARK: - Location
struct Location: Codable {
    let city: String?
    let state: String?
    let country: String?
}

// MARK: - Salary
struct Salary: Codable {
    let min, max: Int?
    let currency: String?
    let period: String?
}

// MARK: - ListDetails
struct ListDetails: Codable {
    let totalResults: Int?
    let currency: String?
    let generatedAt: String?
    let note: String?

    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case currency
        case generatedAt = "generated_at"
        case note
    }
}
