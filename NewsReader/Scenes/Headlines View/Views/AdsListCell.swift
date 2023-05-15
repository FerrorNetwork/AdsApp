import UIKit

final class AdsListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    func configure(
        with viewModel: Ad
    ) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        categoryLabel.text = "\(viewModel.rating)"
    }
    
}
