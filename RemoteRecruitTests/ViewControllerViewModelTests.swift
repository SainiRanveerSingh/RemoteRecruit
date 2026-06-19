//
//  ViewControllerViewModelTests.swift
//  RemoteRecruitTests
//
//  Created by RV on 19/06/26.
//

import Testing
import XCTest

@testable import RemoteRecruit

@MainActor
final class ViewControllerViewModelTests: XCTestCase {

    private var mockService: MockJobService!
    private var viewModel: ViewControllerViewModel!

    override func setUp() {
        super.setUp()
        mockService = MockJobService()
        viewModel = ViewControllerViewModel(service: mockService)
    }

    override func tearDown() {
        mockService = nil
        viewModel = nil
        super.tearDown()
    }

    // MARK: - loadJobs()

    func
        test_loadJobs_whenServiceReturnsJobs_populatesArraysAndCallsReloadData()
        async
    {
        let jobs = [
            Job.make(title: "iOS Developer", company: "Apple"),
            Job.make(title: "Backend Engineer", company: "Google"),
        ]
        mockService.jobsToReturn = jobs

        let reloadExpectation = expectation(description: "reloadData called")
        viewModel.reloadData = { reloadExpectation.fulfill() }
        viewModel.onError = { _ in XCTFail("onError should not be called") }

        viewModel.loadJobs()

        await fulfillment(of: [reloadExpectation], timeout: 1.0)

        XCTAssertEqual(viewModel.arrayJobList.count, 2)
        XCTAssertEqual(viewModel.filteredJobs.count, 2)
        XCTAssertEqual(mockService.fetchJobsCallCount, 1)
    }

    func
        test_loadJobs_whenServiceReturnsEmptyList_callsOnErrorWithNoJobsMessage()
        async
    {
        mockService.jobsToReturn = []

        let errorExpectation = expectation(description: "onError called")
        var receivedMessage: String?

        viewModel.reloadData = { XCTFail("reloadData should not be called") }
        viewModel.onError = { message in
            receivedMessage = message
            errorExpectation.fulfill()
        }

        viewModel.loadJobs()

        await fulfillment(of: [errorExpectation], timeout: 1.0)

        XCTAssertEqual(receivedMessage, "No Jobs available.")
        XCTAssertTrue(viewModel.arrayJobList.isEmpty)
    }

    func test_loadJobs_whenServiceThrows_callsOnErrorWithLocalizedDescription()
        async
    {
        mockService.errorToThrow = MockError.network

        let errorExpectation = expectation(description: "onError called")
        var receivedMessage: String?

        viewModel.reloadData = { XCTFail("reloadData should not be called") }
        viewModel.onError = { message in
            receivedMessage = message
            errorExpectation.fulfill()
        }

        viewModel.loadJobs()

        await fulfillment(of: [errorExpectation], timeout: 1.0)

        XCTAssertEqual(receivedMessage, "Network error occurred")
    }

    // MARK: - search(text:)

    func test_search_withMatchingTitle_filtersJobsByTitle() async {
        await loadSampleJobs()

        let reloadExpectation = expectation(description: "reloadData called")
        viewModel.reloadData = { reloadExpectation.fulfill() }

        viewModel.search(text: "ios")

        await fulfillment(of: [reloadExpectation], timeout: 1.0)

        XCTAssertEqual(viewModel.filteredJobs.count, 1)
        XCTAssertEqual(viewModel.filteredJobs.first?.title, "iOS Developer")
    }

    func test_search_withMatchingCompany_filtersJobsByCompany() async {
        await loadSampleJobs()

        let reloadExpectation = expectation(description: "reloadData called")
        viewModel.reloadData = { reloadExpectation.fulfill() }

        viewModel.search(text: "google")

        await fulfillment(of: [reloadExpectation], timeout: 1.0)

        XCTAssertEqual(viewModel.filteredJobs.count, 1)
        XCTAssertEqual(viewModel.filteredJobs.first?.company, "Google")
    }

    func test_search_isCaseInsensitive() async {
        await loadSampleJobs()

        let reloadExpectation = expectation(description: "reloadData called")
        viewModel.reloadData = { reloadExpectation.fulfill() }

        viewModel.search(text: "APPLE")

        await fulfillment(of: [reloadExpectation], timeout: 1.0)

        XCTAssertEqual(viewModel.filteredJobs.count, 1)
        XCTAssertEqual(viewModel.filteredJobs.first?.company, "Apple")
    }

    func test_search_withNoMatches_returnsEmptyFilteredList() async {
        await loadSampleJobs()

        let reloadExpectation = expectation(description: "reloadData called")
        viewModel.reloadData = { reloadExpectation.fulfill() }

        viewModel.search(text: "nonexistent role")

        await fulfillment(of: [reloadExpectation], timeout: 1.0)

        XCTAssertTrue(viewModel.filteredJobs.isEmpty)
    }

    func test_search_withEmptyText_resetsToFullJobList() async {
        await loadSampleJobs()

        // First narrow the list down
        let firstFilter = expectation(description: "first filter")
        viewModel.reloadData = { firstFilter.fulfill() }
        viewModel.search(text: "ios")
        await fulfillment(of: [firstFilter], timeout: 1.0)
        XCTAssertEqual(viewModel.filteredJobs.count, 1)

        // Then clear the search text
        let resetExpectation = expectation(description: "reset filter")
        viewModel.reloadData = { resetExpectation.fulfill() }
        viewModel.search(text: "")
        await fulfillment(of: [resetExpectation], timeout: 1.0)

        XCTAssertEqual(
            viewModel.filteredJobs.count,
            viewModel.arrayJobList.count
        )
    }

    func test_search_handlesJobsWithNilTitleOrCompanyGracefully() async {
        mockService.jobsToReturn = [
            Job.make(title: nil, company: nil),
            Job.make(title: "Data Scientist", company: nil),
        ]

        let loadExpectation = expectation(description: "initial load")
        viewModel.reloadData = { loadExpectation.fulfill() }
        viewModel.loadJobs()
        await fulfillment(of: [loadExpectation], timeout: 1.0)

        let searchExpectation = expectation(
            description: "search with nil fields"
        )
        viewModel.reloadData = { searchExpectation.fulfill() }
        viewModel.search(text: "data")
        await fulfillment(of: [searchExpectation], timeout: 1.0)

        XCTAssertEqual(viewModel.filteredJobs.count, 1)
    }

    // MARK: - job(at:)

    func test_jobAtIndex_returnsCorrectJobFromFilteredList() async {
        await loadSampleJobs()

        let job = viewModel.job(at: 0)

        XCTAssertEqual(job.title, viewModel.filteredJobs[0].title)
    }

    // MARK: - Helpers

    /// Loads a fixed set of sample jobs into the view model for filter-related tests.
    private func loadSampleJobs() async {
        mockService.jobsToReturn = [
            Job.make(title: "iOS Developer", company: "Apple"),
            Job.make(title: "Backend Engineer", company: "Google"),
        ]

        let expectation = expectation(description: "initial load")
        viewModel.reloadData = { expectation.fulfill() }
        viewModel.loadJobs()
        await fulfillment(of: [expectation], timeout: 1.0)
    }

}
