import Foundation

// MARK: - ApiTransactions
struct ApiTransactionElement: Codable {
    let sku, amount, currency: String
}

typealias ApiTransactions = [ApiTransactionElement]

// MARK: - ApiConversionRates
struct ApiConversionRateElement: Codable {
    let from, to, rate: String
}

typealias ApiConversionRates = [ApiConversionRateElement]
