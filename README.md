# Random Recipe

[![CI](https://github.com/mizanto/recipes-uikit/actions/workflows/ios.yml/badge.svg)](https://github.com/mizanto/recipes-uikit/actions/workflows/ios.yml)

**Random Recipe** is a portfolio project, allows users to:
- Fetch random recipes from the internet.
- Save favorite recipes for quick access later.
- Keep a history of all the recipes that have been fetched.

### Technical Details

- **Backend**: [TheMealDB API](https://www.themealdb.com/api.php) for fetching recipes.
- **Networking**: Uses `URLSession` for network requests.
- **Local Storage**: Utilizes `CoreData` to store favorite recipes and history.
- **Third-party Libraries**: `Kingfisher` for image loading and caching, managed via the Swift Package Manager (SPM).
- **Architecture**: Follows the VIP (View-Interactor-Presenter) pattern for a clear separation of concerns and maintainability.
- **Testing**: Fully covered with unit and UI tests.
- **Continuous Integration**: GitHub Actions is set up to run tests automatically on each commit or pull request.

This project serves as a practical exercise in iOS development, emphasizing clean code, efficient networking, and robust architecture.