import Foundation

class ApiService {
    
    func fetchTransactions(completion: @escaping (Result<[Transaction], GNBError>) -> Void) {
        GNBApi.getRequest(endPoint: .transactions) { result in
            switch result {
                case .success(let data):
                    do {
                        let transactionsApi: ApiTransactions = try JSONDecoder().decode(ApiTransactions.self, from: data)
                        let transactions = transactionsApi.map {
                            Transaction(
                                productId: $0.sku,
                                amount: Double($0.amount) ?? 0,
                                currency: $0.currency)
                        }
                        completion(.success(transactions))
                    } catch {
                        completion(.failure(GNBError(.parseFailed)))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func fetchConversionRates(completion: @escaping (Result<[ConversionRate], GNBError>) -> Void) {
        GNBApi.getRequest(endPoint: .conversionRates) { result in
            switch result {
                case .success(let data):
                    do {
                        let conversionRatesApi: ApiConversionRates = try JSONDecoder().decode(ApiConversionRates.self, from: data)
                        let conversions = conversionRatesApi.map {
                            ConversionRate(
                                from: $0.from,
                                to: $0.to,
                                rate: Double($0.rate) ?? 0)
                        }
                        completion(.success(conversions))
                    } catch {
                        completion(.failure(GNBError(.parseFailed)))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
