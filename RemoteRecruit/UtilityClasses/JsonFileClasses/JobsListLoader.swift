//
//  JobsListLoader.swift
//  RemoteRecruit
//
//  Created by RV on 18/06/26.
//

import Foundation

protocol JobListProtocol {
    func fetchJobs() async throws -> [Job]
}

final class JobListService: JobListProtocol {

    func fetchJobs() async throws -> [Job] {

        try await Task.sleep(nanoseconds: 500_000_000)

        guard let url = Bundle.main.url(
            forResource: "jobs",
            withExtension: "json"
        ) else {
            throw NSError(
                domain: "JSON",
                code: 404,
                userInfo: [
                    NSLocalizedDescriptionKey: "jobs.json file not found. Please try again."
                ]
            )
        }

        let data = try Data(contentsOf: url)

        let response = try JSONDecoder()
            .decode(JobsListResponse.self, from: data)

        return response.data?.jobs ?? [Job]()
    }
}

enum JobsListLoaderError: Error {
    case fileNotFound
    case decodingFailed(Error)
}

final class JobsListLoader {

    static func loadJobs(filename: String = "jobs") -> [Job] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("⚠️ Could not find \(filename).json in bundle")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(JobsListResponse.self, from: data)
            return response.data?.jobs ?? [Job]()
        } catch {
            print("⚠️ Failed to decode jobs.json: \(error)")
            return []
        }
    }
}
