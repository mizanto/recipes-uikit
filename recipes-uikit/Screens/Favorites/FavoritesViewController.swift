//
//  FavoritesViewController.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func displayFavoriteRecipes(_ viewModel: [FavoriteRecipeViewModel])
    func displayError(_ message: String)
}

class FavoritesViewController: UIViewController {
    
    var interactor: FavoritesInteractorProtocol?
    
    private let tableView = UITableView()
    private var favoriteRecipes: [FavoriteRecipeViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        view.backgroundColor = .white
        title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchFavoriteRecipes()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: "RecipeTableViewCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        let recipe = favoriteRecipes[indexPath.row]
        cell.configure(with: recipe)
        return cell
    }
}

extension FavoritesViewController: FavoritesViewProtocol {
    func displayFavoriteRecipes(_ viewModel: [FavoriteRecipeViewModel]) {
        self.favoriteRecipes = viewModel
        tableView.reloadData()
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
