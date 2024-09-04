//
//  FavoritesViewController.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import UIKit

import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func displayFavoriteRecipes(_ viewModel: [FavoriteRecipeViewModel])
    func displayError(_ message: String)
}

class FavoritesViewController: UIViewController, FavoritesViewProtocol {
    
    var interactor: FavoritesInteractorProtocol?
    private var favoriteRecipes: [FavoriteRecipeViewModel] = []

    private lazy var collectionView: UICollectionView = {
        let layout = createFavoritesLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavoriteRecipeCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteRecipeCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        view.backgroundColor = .white
        title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchFavoriteRecipes()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - FavoritesViewProtocol
    
    func displayFavoriteRecipes(_ viewModel: [FavoriteRecipeViewModel]) {
        self.favoriteRecipes = viewModel
        collectionView.reloadData()
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteRecipeCollectionViewCell.identifier, for: indexPath) as? FavoriteRecipeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let recipe = favoriteRecipes[indexPath.row]
        cell.configure(with: recipe)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let deleteAction = UIAction(title: "Delete", attributes: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            let recipeToDelete = self.favoriteRecipes[indexPath.row]
            self.interactor?.removeRecipeFromFavorites(recipeToDelete)
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            return UIMenu(title: "", children: [deleteAction])
        })
    }
}

private extension FavoritesViewController {
    func createFavoritesLayout() -> UICollectionViewCompositionalLayout {
        // Cell Size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Cell Insets
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
