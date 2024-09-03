//
//  RandomRecipeViewController.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import UIKit

class RandomRecipeViewController: UIViewController {
    
    // TODO: Add a stub view for the first try

    private let networkService = NetworkService()
    private let storageService: StorageServiceProtocol
    private let recipeView = RecipeView()
    
    private let getRecipeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Random Recipe", for: .normal)
        button.addTarget(self, action: #selector(getRandomRecipe), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var currentRecipe: Recipe? {
        didSet {
            if let recipe = currentRecipe {
                recipeView.isHidden = false
                navigationItem.title = recipe.mealName
                recipeView.configure(with: recipe)
            } else {
                recipeView.isHidden = true
            }
        }
    }

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    init(storageService: StorageServiceProtocol = StorageService()) {
            self.storageService = storageService
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            self.storageService = StorageService()
            super.init(coder: coder)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // TODO: add logic to check if the recipe in favs
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(addToFavorites))
        
        navigationItem.rightBarButtonItem = favoriteButton
        
        setupUI()
        
        currentRecipe = storageService.loadLastViewedRecipe()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(recipeView)
        recipeView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(getRecipeButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: getRecipeButton.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            recipeView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            recipeView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            recipeView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            recipeView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            recipeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            getRecipeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            getRecipeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            getRecipeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            getRecipeButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        recipeView.isHidden = true
    }
    
    @objc private func getRandomRecipe() {
        Task {
            do {
                let recipe = try await networkService.fetchRandomRecipe()
                DispatchQueue.main.async {
                    self.currentRecipe = recipe
                    self.storageService.saveLastRecipe(recipe)
                    self.scrollView.setContentOffset(.zero, animated: true)
                }
            } catch {
                print("Failed to fetch recipe: \(error)")
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Failed to fetch recipe. Please try again.")
                }
            }
        }
    }
    
    @objc private func addToFavorites() {
        // TODO: add fav logic
        print("Added to favorite")
        // navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
