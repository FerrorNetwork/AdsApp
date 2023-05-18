import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private enum Constants {
    static let adCell = "AdsListCell"
    static let sideInset: CGFloat = 16
    static let itemsPadding: CGFloat = 16
}

final class AdsListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
        
    typealias ViewModel = AdsListViewModel
    
    let viewModel: ViewModel
    
    private var disposeBag = DisposeBag()
    
    private lazy var dataSource = RxCollectionViewSectionedAnimatedDataSource<AdsSection>(
        configureCell: { (dataSource, collectionView: UICollectionView, indexPath, item) in
            switch item {
                
            case .activityIndicator:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityIndicatorCell.id, for: indexPath) as! ActivityIndicatorCell
                cell.startAnimating()
                return cell
                
            case .ad(let ad):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.adCell, for: indexPath) as! AdsListCell
                cell.configure(with: ad)
                return cell
                
            }
        }
    )
    
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
        configureCollectionView()
    }
    
    func configureCollectionView() {

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(
            top: Constants.itemsPadding/2,
            left: Constants.sideInset,
            bottom: Constants.itemsPadding/2,
            right: Constants.sideInset
        )
        flowLayout.minimumLineSpacing = Constants.itemsPadding
        flowLayout.minimumInteritemSpacing = Constants.itemsPadding
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        let nib = UINib(nibName: Constants.adCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.adCell)
        collectionView.register(ActivityIndicatorCell.self, forCellWithReuseIdentifier: ActivityIndicatorCell.id)
        
        let refreshConrol = UIRefreshControl()
        collectionView.refreshControl = refreshConrol
        refreshConrol
            .rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.reloadingTrigger)
            .disposed(by: disposeBag)
        
        collectionView
            .rx
            .contentOffset
            .map(\.y)
            .filter { [unowned self] y in
                let height = collectionView.frame.size.height
                let distanceFromBottom = collectionView.contentSize.height - y
                return distanceFromBottom < height
            }
            .throttle(.seconds(3), latest: true, scheduler: MainScheduler.instance)
            .map { _ in }
            .bind(to: viewModel.nextPageTrigger)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .itemSelected
            .asDriver()
            .drive(onNext: { [unowned self] ip in
                collectionView.deselectItem(at: ip, animated: true)
                
                let item = self.dataSource[ip.section].items[ip.item]
                guard case .ad(let ad) = item else {
                    return
                }
                self.viewModel.navigateToAd(with: ad.id)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .ads
            .do(onNext: { _ in
                refreshConrol.endRefreshing()
            })
            .drive(
                collectionView.rx.items(dataSource: dataSource)
            )
            .disposed(by: disposeBag)
    }
    
}

extension AdsListViewController: UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let type = dataSource[indexPath.section].items[indexPath.item]
        
        switch type {
            
        case .activityIndicator:
            return CGSize(width: collectionView.bounds.width, height: 100)
            
        case .ad:
            return CGSize(
                width: (collectionView.bounds.width - Constants.sideInset * 2 - Constants.itemsPadding) / 2,
                height: 400
            )
            
        }
        
    }
    
}
