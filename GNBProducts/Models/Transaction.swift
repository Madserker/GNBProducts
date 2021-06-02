import Foundation

class Transaction {
    public var productId: String
    public var amount: Double
    public var currency: String
    
    init(productId: String, amount: Double, currency: String) {
        self.productId = productId
        self.amount = amount
        self.currency = currency
    }
}
