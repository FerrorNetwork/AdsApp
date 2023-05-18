import UIKit
import SwiftUI
import XCoordinator

typealias AdsRouteTrigger = (AdsRoute) -> Void

enum AdsRoute: Route {
    case list
    case details(UUID)
}

final class AdsCoordinator: NavigationCoordinator<AdsRoute> {
    
    private let service: AdsServiceType
    
    init(
        rootViewController: RootViewController = .init(),
        service: AdsServiceType
    ) {
        self.service = service
        super.init(rootViewController: rootViewController)
        rootViewController.navigationBar.prefersLargeTitles = true
    }
    
    override func prepareTransition(
        for route: AdsRoute
    ) -> NavigationTransition {
        
        switch route {
            
        case .list:
            let viewModel = AdsListViewModel(
                service: service,
                routeTrigger: { [unowned self] route in
                    self.trigger(route)
                }
            )
            let viewController = AdsListViewController(viewModel: viewModel)
            viewController.title = "Evetto"
            return .push(viewController)
            
        case .details(let adId):
            let adDetails = service.getAdDetails(adId)
            let viewModel = AdDetailsViewModel(adDetails: adDetails)
            let view = AdDetailsView(viewModel: viewModel)
            let viewController = AdDetailsViewController(rootView: view)
            return .push(viewController)
            
        }
        
    }
    
}
