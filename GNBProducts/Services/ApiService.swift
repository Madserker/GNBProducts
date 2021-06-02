import Foundation

class ApiService {
    
    func fetchTransactions(completion: @escaping ([Transaction]) -> Void) {
        GNBApi.getRequest(endPoint: .transactions) { data in
            do {
                let transactionsApi: ApiTransactions = try JSONDecoder().decode(ApiTransactions.self, from: data)
                let transactions = transactionsApi.map {
                    Transaction(
                        productId: $0.sku,
                        amount: Double($0.amount) ?? 0,
                        currency: $0.currency)
                }
                completion(transactions)
            } catch {
                print(error)
            }
        }
    }
    
    func fetchConversionRates(completion: @escaping ([ConversionRate]) -> Void) {
        GNBApi.getRequest(endPoint: .conversionRates) { data in
            do {
                let conversionRatesApi: ApiConversionRates = try JSONDecoder().decode(ApiConversionRates.self, from: data)
                let conversions = conversionRatesApi.map {
                    ConversionRate(
                        from: $0.from,
                        to: $0.to,
                        rate: Double($0.rate) ?? 0)
                }
                completion(conversions)
            } catch {
                print(error)
            }
        }
    }
}
