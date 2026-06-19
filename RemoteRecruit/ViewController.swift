//
//  ViewController.swift
//  RemoteRecruit
//
//  Created by RV on 18/06/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableJobList: RecruitListTableView!
    @IBOutlet weak var labelLoading: UILabel!
    let viewModel = ViewControllerViewModel(service: JobListService())
    //Pull to Refresh Code
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func initialSetup() {
        viewModel.setupNavigationBar(for: self)
        hideKeyboardWhenTappedAround()
        configureTableView()
        configureSearchBar()
        loadJobListData()
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search by job title or company"
    }
    
    func configureTableView() {
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableJobList.addSubview(refreshControl)
        
        tableJobList.configure(viewModel)
        
        tableJobList.didSelect = { [weak self] (index) in
            guard let self = self else { return }
            if viewModel.filteredJobs.count > index {
                let objTarget = MainStoryboard
                    .instantiateViewController(withIdentifier: "JobDetailViewController") as! JobDetailViewController
                objTarget.jobDetailViewModel.jobData = viewModel.filteredJobs[index]
                self.navigationController?.pushViewController(objTarget, animated: true)
            }
        }
        
        viewModel.reloadData = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                LoaderView.shared.hide()
                self.tableJobList.displayData()
                self.refreshControl.endRefreshing()
                self.labelLoading.isHidden = !self.viewModel.arrayJobList.isEmpty
            }
        }
        
        viewModel.onError = { [weak self] message in
            guard let self = self else { return }
            DispatchQueue.main.async {
                LoaderView.shared.hide()
                self.refreshControl.endRefreshing()
                self.labelLoading.isHidden = false
                self.labelLoading.text = message
            }
        }
    }
    
    func loadJobListData() {
        LoaderView.shared.show(in: self.view, message: "Please wait...")
        labelLoading.text = "Loading Data..."
        labelLoading.isHidden = false
        viewModel.loadJobs()
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh
        loadJobListData()
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.search(text: "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
}

