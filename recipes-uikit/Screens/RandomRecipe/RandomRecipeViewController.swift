//
//  RandomRecipeViewController.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import UIKit

class RandomRecipeViewController: UIViewController {

    private let recipeService = RecipeService()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupUI()
        loadLastViewedRecipe()
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
    
    private func loadLastViewedRecipe() {
        if let data = UserDefaults.standard.data(forKey: "lastRecipe"),
           let savedRecipe = try? JSONDecoder().decode(Recipe.self, from: data) {
            currentRecipe = savedRecipe
        } else {
            currentRecipe = nil
        }
    }
    
    private func saveLastRecipe(_ recipe: Recipe) {
        if let data = try? JSONEncoder().encode(recipe) {
            UserDefaults.standard.set(data, forKey: "lastRecipe")
        }
    }
    
    @objc private func getRandomRecipe() {
        Task {
            do {
                let recipe = try await recipeService.fetchRandomRecipe()
                DispatchQueue.main.async {
                    self.currentRecipe = recipe
                    self.saveLastRecipe(recipe)
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
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
