import Foundation

// MARK: - ApiTransactions
struct ApiTransactionElement: Decodable {
    let sku, amount, currency: String
}

typealias ApiTransactions = [ApiTransactionElement]

// MARK: - ApiConversionRates
struct ApiConversionRateElement: Decodable {
    let from, to, rate: String
}

typealias ApiConversionRates = [ApiConversionRateElement]
