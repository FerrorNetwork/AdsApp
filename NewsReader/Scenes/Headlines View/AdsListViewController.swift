import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private enum Constants {
    static let adCell = "AdsListCell"
}

final class AdsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
        
    typealias ViewModel = AdsViewModel
    
    let viewModel: ViewModel
    
    private var disposeBag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<AdsSection> { (dataSource, tableView: UITableView, indexPath, item) in
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.adCell) as! AdsListCell
        cell.configure(with: item)
        return cell
    }
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
}

private extension AdsListViewController {
    
    func configureViews() {
        configureTableView()
    }
    
    func configureTableView() {
        let nib = UINib(nibName: Constants.adCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.adCell)
        
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [unowned self] ip in
                tableView.deselectRow(at: ip, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .headlines
            .drive(
                tableView.rx.items(dataSource: dataSource)
            )
            .disposed(by: disposeBag)
    }
    
}
