//
//  RandomRecipeViewController.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import UIKit

protocol RandomRecipeViewProtocol: AnyObject {
    func displayRecipe(_ viewModel: RandomRecipeViewModel)
    func displayError(_ message: String)
}

class RandomRecipeViewController: UIViewController, RandomRecipeViewProtocol {
    
    var interactor: RandomRecipeInteractorProtocol?
    private let recipeView = RecipeView()
    
    private let getRecipeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Random Recipe", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(addToFavorites))
        navigationItem.rightBarButtonItem = favoriteButton
        
        setupUI()
        
        interactor?.loadLastViewedRecipe()
        
        getRecipeButton.addTarget(self, action: #selector(getRandomRecipe), for: .touchUpInside)
    }
    
    private func setupUI() {
        recipeView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(recipeView)
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
        interactor?.fetchRandomRecipe()
    }
    
    @objc private func addToFavorites() {
        interactor?.saveRecipeToFavorites()
    }
    
    // MARK: - RandomRecipeViewProtocol
    
    // TODO: add epty state
    
    func displayRecipe(_ viewModel: RandomRecipeViewModel) {
        recipeView.isHidden = false
        navigationItem.title = viewModel.mealName
        recipeView.configure(with: viewModel)
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
