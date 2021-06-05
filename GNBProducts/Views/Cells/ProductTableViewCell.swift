import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productIdLabel: UILabel!
    @IBOutlet weak var generalView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupUI() {
        productIdLabel.font = UIFont(name: productIdLabel.font.fontName, size: 25)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func generateCell(productId: String) {
        productIdLabel.text = productId 
    }
    
    override func prepareForReuse() {
        productIdLabel.text = ""
    }
    
}
