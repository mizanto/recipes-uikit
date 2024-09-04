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

class FavoritesViewController: UIViewController, FavoritesViewProtocol {
    
    var interactor: FavoritesInteractorProtocol?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var favoriteRecipes: [FavoriteRecipeViewModel] = []
    
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavoriteRecipeCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteRecipeCollectionViewCell.identifier)
        
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

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let itemsPerRow: CGFloat = 2
            let padding: CGFloat = 16
            let totalPadding = padding * (itemsPerRow + 1)
            let availableWidth = collectionView.frame.width - totalPadding
            let widthPerItem = availableWidth / itemsPerRow

            let aspectRatio: CGFloat = 1.2
            let heightPerItem = widthPerItem * aspectRatio

            return CGSize(width: widthPerItem, height: heightPerItem)
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
