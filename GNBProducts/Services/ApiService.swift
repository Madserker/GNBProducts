import Foundation

class ApiService {
    
    func fetchTransactions() {
        GNBApi.getRequest(endPoint: .transactions) { data in
            print(data)
        }
    }
}
