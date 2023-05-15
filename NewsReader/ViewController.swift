import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let service = AdsService()
        let viewModel = AdsViewModel(service: service)
        let viewController = AdsListViewController(viewModel: viewModel)
        present(viewController, animated: false)
    }

}
