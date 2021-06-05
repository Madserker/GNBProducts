import UIKit

class ProductollectionViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func generateCell(_ product: Product) {
        productNameLabel.text = product.productId
    }

}
