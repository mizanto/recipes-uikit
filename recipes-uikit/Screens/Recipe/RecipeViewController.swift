//
//  RandomRecipeViewController.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import UIKit

protocol RecipeViewProtocol: AnyObject {
    func displayRecipe(_ viewModel: RecipeViewModel)
    func displayError(_ message: String)
}

class RecipeViewController: UIViewController {

    enum ScreenType {
        case random
        case detail
    }

    var interactor: RecipeInteractorProtocol?

    let recipeView = RecipeView()

    private let screenType: ScreenType

    private lazy var getRecipeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            NSLocalizedString("get_random_recipe_button.title", comment: ""),
            for: .normal
        )
        button.accessibilityIdentifier = "GetRecipeButton"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(getRandomRecipe), for: .touchUpInside)
        return button
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    init(screenType: ScreenType) {
        self.screenType = screenType
        super.init(nibName: nil, bundle: nil)
        AppLogger.shared.info("RecipeViewController initialized with screen type: \(screenType)", category: .ui)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AppLogger.shared.info("viewDidLoad called", category: .ui)
        setupNavigationBar()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppLogger.shared.info("viewWillAppear called", category: .ui)
        interactor?.fetchRecipe()
    }

    private func setupUI() {
        recipeView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(recipeView)

        if screenType == .random {
            view.addSubview(getRecipeButton)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        if screenType == .random {
            NSLayoutConstraint.activate([
                scrollView.bottomAnchor.constraint(equalTo: getRecipeButton.topAnchor, constant: -10),
                getRecipeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                getRecipeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                getRecipeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                getRecipeButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        } else {
            NSLayoutConstraint.activate([
                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }

        NSLayoutConstraint.activate([
            recipeView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            recipeView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            recipeView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            recipeView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            recipeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        recipeView.isHidden = true
        AppLogger.shared.info("UI setup completed", category: .ui)
    }

    private func setupNavigationBar() {
        view.backgroundColor = .white

        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(toggleFavoriteStatus)
        )
        favoriteButton.accessibilityIdentifier = "FavoriteButton"
        navigationItem.rightBarButtonItem = favoriteButton
        AppLogger.shared.info("Navigation bar setup completed", category: .ui)
    }

    @objc
    func getRandomRecipe() {
        AppLogger.shared.info("Get Random Recipe button tapped", category: .ui)
        if let randomInteractor = interactor as? RecipeRandomInteractorProtocol {
            randomInteractor.fetchRandomRecipe()
        } else {
            AppLogger.shared.error("This screen does not support fetching a random recipe.", category: .ui)
            displayError("This screen does not support fetching a random recipe.")
        }
    }

    @objc
    func toggleFavoriteStatus() {
        AppLogger.shared.info("Toggle favorite status button tapped", category: .ui)
        interactor?.toggleFavoriteStatus()
    }
}

// MARK: - RecipeViewProtocol

extension RecipeViewController: RecipeViewProtocol {
    func displayRecipe(_ viewModel: RecipeViewModel) {
        recipeView.isHidden = false
        navigationItem.title = viewModel.mealName
        recipeView.configure(with: viewModel)

        let imageName = viewModel.isFavorite ? "star.fill" : "star"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
        navigationItem.rightBarButtonItem?.tintColor = viewModel.isFavorite ? .orange : .gray

        AppLogger.shared.info("Recipe displayed: \(viewModel.mealName)", category: .ui)
    }

    func displayError(_ message: String) {
        AppLogger.shared.error("Error displayed: \(message)", category: .ui)
        let alert = UIAlertController(
            title: NSLocalizedString("error.title", comment: ""),
            message: message,
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: NSLocalizedString("ok_button.title", comment: ""),
                          style: .default)
        )
        present(alert, animated: true)
    }
}
