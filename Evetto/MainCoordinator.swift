import UIKit
import XCoordinator

enum MainRoute: Route {
    case auth
    case ads
    case error(Error)
}

final class MainCoordinator: NavigationCoordinator<MainRoute> {
    
    private let depedencyContainer: DependencyContainer
    
    init(
        dependencyContainer: DependencyContainer
    ) {
        self.depedencyContainer = dependencyContainer
        super.init(initialRoute: .ads)
    }
    
    override func prepareTransition(
        for route: MainRoute
    ) -> NavigationTransition {
    
        switch route {
            
        case .auth:
            let alert = UIAlertController(
                title: "Необходима авторизация",
                message: nil,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: { _ in }
            ))
            return .present(alert)
            
        case .ads:
            do {
                let coordinator = AdsCoordinator(
                    rootViewController: rootViewController,
                    service: try depedencyContainer.getAdsService()
                )
                addChild(coordinator)
                return .trigger(.list, on: coordinator)
            } catch {
                return .trigger(.error(error), on: self)
            }
            
        case .error(let error):
            let alert = UIAlertController(
                title: "Возникла ошибка",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "OK", style: .default, handler: { _ in }))
            return .present(alert)
            
        }
        
    }
    
}
