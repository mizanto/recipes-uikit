//
//  FavoritesViewController.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func displayFavoriteRecipes(_ viewModel: [FavoriteRecipeViewModel])
    func displayPlaceholder()
    func displayError(_ message: String)
}

class FavoritesViewController: UIViewController {

    var interactor: FavoritesInteractorProtocol?
    private var favoriteRecipes: [FavoriteRecipeViewModel] = []

    lazy var collectionView: UICollectionView = {
        let layout = createFavoritesLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.accessibilityIdentifier = "FavoritesCollectionView"
        return collectionView
    }()

    private let placeholderView: PlaceholderView = {
        let placeholder = PlaceholderView(type: .noFavorites)
        placeholder.accessibilityIdentifier = "FavoritesPlaceholderView"
        return placeholder
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        AppLogger.shared.info("Favorites screen loaded", category: .ui)
        setupCollectionView()
        setupPlaceholderView()

        view.backgroundColor = .white
        title = NSLocalizedString("favorites_screen.title", comment: "")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppLogger.shared.info("Fetching favorite recipes", category: .database)
        interactor?.fetchFavoriteRecipes()
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavoriteRecipeCollectionViewCell.self,
                                forCellWithReuseIdentifier: FavoriteRecipeCollectionViewCell.identifier)

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupPlaceholderView() {
        view.addSubview(placeholderView)
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.isHidden = true

        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: view.topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func showErrorAlert(message: String) {
        AppLogger.shared.error("Displaying error alert: \(message)", category: .ui)
        let alert = UIAlertController(
            title: NSLocalizedString("error.title", comment: ""), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok_button.title", comment: ""), style: .default))
        present(alert, animated: true)
    }

    private func createFavoritesLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(240))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(240))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func deleteFavoriteRecipe(at indexPath: IndexPath) {
        let recipeToDelete = favoriteRecipes[indexPath.row]
        AppLogger.shared.info("Deleting favorite recipe: \(recipeToDelete.mealName)", category: .ui)
        interactor?.removeRecipeFromFavorites(withId: recipeToDelete.id)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteRecipeCollectionViewCell.identifier,
            for: indexPath) as? FavoriteRecipeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let recipe = favoriteRecipes[indexPath.row]
        cell.configure(with: recipe)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRecipe = favoriteRecipes[indexPath.row]
        AppLogger.shared.info("Selected favorite recipe: \(selectedRecipe.mealName)", category: .ui)
        interactor?.selectRecipe(withId: selectedRecipe.id)
    }

    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        let deleteAction = UIAction(title: NSLocalizedString("delete_action.title", comment: ""),
                                    attributes: .destructive) { [weak self] _ in
            self?.deleteFavoriteRecipe(at: indexPath)
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            return UIMenu(title: "", children: [deleteAction])
        })
    }
}

// MARK: - FavoritesViewProtocol

extension FavoritesViewController: FavoritesViewProtocol {
    func displayFavoriteRecipes(_ viewModel: [FavoriteRecipeViewModel]) {
        AppLogger.shared.info("Displaying \(viewModel.count) favorite recipes", category: .ui)
        self.favoriteRecipes = viewModel
        collectionView.isHidden = false
        placeholderView.isHidden = true
        collectionView.reloadData()
    }

    func displayError(_ message: String) {
        AppLogger.shared.error("Error displaying favorites: \(message)", category: .ui)
        showErrorAlert(message: message)
    }

    func displayPlaceholder() {
        AppLogger.shared.info("Displaying placeholder", category: .ui)
        placeholderView.isHidden = false
        collectionView.isHidden = true
    }
}
