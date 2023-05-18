import UIKit
import NukeUI

final class AdsListCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: LazyImageView!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else {
            return
        }
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
    }
    
    func configure(
        with viewModel: AdsListItemViewModel
    ) {
        titleLabel.text = viewModel.title
        locationLabel.text = viewModel.location
        priceLabel.text = viewModel.price
        dateLabel.text = viewModel.date
        imageView.placeholderView = UIActivityIndicatorView()
        imageView.url = viewModel.imageURL
    }
    
}
