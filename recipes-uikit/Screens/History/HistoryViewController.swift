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
    
    // TODO: add timestamps to items in table
    
    var interactor: HistoryInteractorProtocol?
    
    private let tableView = UITableView()
    private var recipes: [HistoryViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        view.backgroundColor = .white
        title = "History"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Clear",
            style: .plain,
            target: self,
            action: #selector(clearHistory)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchHistory()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
    
    @objc private func clearHistory() {
        let alertController = UIAlertController(
            title: "Clear History",
            message: "Are you sure you want to clear all recipe history? This action cannot be undone.",
            preferredStyle: .alert
        )

        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            self?.interactor?.clearHistory()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(clearAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func showErrorAlert(message: String) {
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HistoryViewController: HistoryViewProtocol {
    func displayRecipeHistory(_ viewModel: [HistoryViewModel]) {
        self.recipes = viewModel
        tableView.reloadData()
    }
    
    func displayError(_ message: String) {
        showErrorAlert(message: message)
    }
}
