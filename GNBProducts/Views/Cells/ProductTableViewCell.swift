import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productIdLabel: UILabel!
    @IBOutlet weak var generalView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        generalView.layer.cornerRadius = 8
        generalView.layer.masksToBounds = true
        generalView.backgroundColor = .lightGray
        
        productIdLabel.font = UIFont.systemFont(ofSize: 20)
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
