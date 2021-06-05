import Foundation

class Product {
    var id: String
    var transactions: [Double]
    
    init(id: String, transactions: [Double]) {
        self.id = id
        self.transactions = transactions
    }
}
