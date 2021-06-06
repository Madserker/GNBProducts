import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var transactionAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        transactionAmountLabel.font = UIFont.systemFont(ofSize: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        transactionAmountLabel.text = ""
        transactionAmountLabel.font = UIFont.systemFont(ofSize: 20)
    }
    
    public func generateCell(amount: String, finalCell: Bool = false) {
        transactionAmountLabel.text = amount
        
        if finalCell {
            transactionAmountLabel.font = UIFont.systemFont(ofSize: 26)
        }
    }
}
