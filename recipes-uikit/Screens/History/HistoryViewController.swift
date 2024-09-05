//
//  HistoryViewController.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import UIKit

protocol HistoryViewProtocol: AnyObject {
    func displayRecipeHistory(_ viewModel: [HistoryViewModel])
    func displayError(_ message: String)
}

class HistoryViewController: UIViewController {
    
    var interactor: HistoryInteractorProtocol?
    
    private let tableView = UITableView()
    private var recipes: [HistoryViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        AppLogger.shared.info("HistoryViewController loaded", category: .ui)
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppLogger.shared.info("Fetching recipe history", category: .ui)
        interactor?.fetchHistory()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: "HistoryTableViewCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "History"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Clear",
            style: .plain,
            target: self,
            action: #selector(clearHistory)
        )
    }
    
    @objc private func clearHistory() {
        AppLogger.shared.info("Clear history button tapped", category: .ui)
        let alertController = UIAlertController(
            title: "Clear History",
            message: "Are you sure you want to clear all recipe history? This action cannot be undone.",
            preferredStyle: .alert
        )

        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            AppLogger.shared.info("User confirmed clearing history", category: .ui)
            self?.interactor?.clearHistory()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            AppLogger.shared.info("User cancelled clearing history", category: .ui)
        }

        alertController.addAction(clearAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        AppLogger.shared.error("Displaying error alert: \(message)", category: .ui)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        let recipe = recipes[indexPath.row]
        cell.configure(with: recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppLogger.shared.info("Selected recipe at index: \(indexPath.row)", category: .ui)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HistoryViewController: HistoryViewProtocol {
    func displayRecipeHistory(_ viewModel: [HistoryViewModel]) {
        AppLogger.shared.info("Displaying fetched recipe history", category: .ui)
        self.recipes = viewModel
        tableView.reloadData()
    }
    
    func displayError(_ message: String) {
        AppLogger.shared.error("Error received from interactor: \(message)", category: .ui)
        showErrorAlert(message: message)
    }
}
