//
//  TransactionTableViewCell.swift
//  GNBProducts
//
//  Created by Sergi Hurtado on 05/06/2021.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var transactionAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the v<iew for the selected state
    }
    
    public func generateCell(amount: String) {
        transactionAmountLabel.text = amount
    }
    
}
