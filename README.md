# Pays app
Une application simple qui a seulement 2 écrans, `ListView` et `DetailView`.
- `ListView` affiche une liste de pays et son drapeau. Il est aussi possible de rechercher un pays en écrivant son nom.
- `DetailView` affiche les détails du pays selectioné, son drapeau, continent, nombre de la population et la capitale.

## Architecture
Comment est une application simple, j'ai utilisé une architecture `MVVM` pour séparer les reponsabilités.
- Le suffixe `View` signifie que le document est un écran et est seulement responsable pour afficher le contenu.
- Le suffixe `ViewModel` signifie que le document est responsable pour les "business rules".
- Le suffixe `Service` signifie que le document est responsable pour faire l'appel à l'API.
- Les documents avec le préfixe `Network` sont une couche que j'ai écrit responsable d'organiser tout ce qui est nécessaire pour faire des demandes à un serveur. Ma référence était [Moya](https://github.com/Moya/Moya).

Je choisi pour utiliser `SwiftUI` pour les views et `Combine` pour faire appels à l'API. Il y a une fonction que fait l'appel en utilisant `SwiftConcurrency` mais elle n'est pas utilisée.

## Tests
Je suis en train d'étudier `SwiftTesting` et je choisi en l'utiliser ici. Je suis habitué à utiliser `XCTest` mais j'ai choisi de prendre le risque avec le nouveau cadre de test.


# Countries app
A really simple application that only has 2 views, `ListView` and `DetailView`.
- `ListView` shows a list of countries and their flag. It's also possible to search for a country using its name.
- `DetailView` shows the details of a selected country, its flag, continent, population and the capital.

## Architecture
Since it's a simple app, I chose to use `MVVM` to segregate responsibilities.
- All files ending with `View` are views and are only responsible for show the contents.
- Files ending with `ViewModel` are responsible for the businnes logic.
- Files ending with `Service` are responsible for making API requests.
- Files starting with `Network` are a layer I created responsible for organizing everything that is needed to make requests to a server. I used [Moya](https://github.com/Moya/Moya) as reference.

## Tests
I'm studying `SwiftTesting` and I chose to use it here. I'm used to `XCTest` but I chose to take the risk with the new framework.
