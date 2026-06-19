# RemoteRecruit
This is a Test iOS application that allows users to browse available jobs, search for jobs, and view job details.

Setup Instructions
Clone the repository: 
https://github.com/SainiRanveerSingh/RemoteRecruit.git

Open RemoteRecruit.xcodeproj in Xcode (15+ recommended).
Select a simulator (or device) and hit Run (⌘R). No API keys, signing changes, or third-party package setup are required — the app reads job data from a bundled local JSON file, so it works fully offline.
To run the test suite, select the RemoteRecruitTests scheme and run

====================================================================

Architecture explanation
The app follows MVVM with a thin, protocol-driven service layer:

Models (Job, Location, Salary, JobsListResponse, etc.) are Codable structs mapped directly from the JSON shape, including snake_case API keys via CodingKeys.
Service layer (JobListProtocol / JobListService) abstracts where job data comes from. The view model depends only on the protocol, so the underlying source (local JSON today, a remote API tomorrow) can change without touching the view model or view layer.
ViewModel (ViewControllerViewModel) owns all business logic: fetching jobs, filtering by search text, and exposing reloadData / onError closures so the view layer stays passive. It is marked @MainActor since it drives UI-facing closures directly.
View layer is split into a UIViewController, a custom UITableView subclass (RecruitListTableView) that owns its own UITableViewDataSource/UITableViewDelegate conformance, and a UITableViewCell subclass (RecruitListTableViewCell) responsible only for rendering a given Job — no business logic lives in the view layer.
Dependency injection: ViewControllerViewModel is initialized with a JobListProtocol instance, so tests can inject a mock service instead of hitting real data.

====================================================================

Data Source
This project uses a local JSON file (jobs.json) bundled with the app as its mock data source, rather than a public or self-hosted API. JobListService.fetchJobs():


Locates jobs.json in the app bundle.
Loads and decodes it into JobsListResponse via JSONDecoder.
Returns response.data?.jobs ?? [].


A short artificial delay (Task.sleep) is added before the fetch to make the loading state visibly testable in the UI rather than resolving instantly.

Because JobListService is exposed only through the JobListProtocol interface, switching to a real network-backed implementation later is a drop-in change — no other layer needs to know.

====================================================================

State Handling
The view model surfaces three states to the view layer via closures:

StateHow it's triggered
LoadingView controller shows a loading indicator while loadJobs()'s Task is in flight.
EmptyloadJobs() calls onError?("No Jobs available.") when the fetched list is empty.
ErrorloadJobs() calls onError?(error.localizedDescription) if decoding/loading throws.
SuccessreloadData?() is called once jobs are fetched and filtered, prompting the table view to reload.

====================================================================

Assumptions
Search is treated as a live, case-insensitive substring match against title OR company (not an exact or prefix match), matching common job-board UX.
A local JSON file was chosen over a public API or mock server (JSON Server/Mockoon) to keep the project fully offline and reviewable without any external dependency or setup step — the task explicitly allows this as an option.
salary.currency defaults to "INR" and missing min/max default to 0 when absent in the source data, rather than hiding the salary label entirely, since the spec calls for salary range to always be visible.
Job location is rendered as "<city>, <country>"; state is parsed but not currently displayed, since the brief only asked for "job location" without specifying granularity.
Empty search text resets to the full, unfiltered job list rather than showing zero results.
No persistence/caching layer was added since the data source is a static bundled file; this would be the first thing introduced if/when a real network API is swapped in.

====================================================================
