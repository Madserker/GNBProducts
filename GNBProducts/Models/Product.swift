import Foundation

class Product {
    var productId: String
    var transactions: [Transaction]
    
    init(productId: String, transactions: [Transaction]) {
        self.productId = productId
        self.transactions = transactions
    }
}
