import Foundation

class GNBApi {
    public static let host = "http://quiet-stone2094.herokuapp.com"
    
    enum EndPoint: String {
        case conversionRates = "rates.json"
        case transactions = "transactions.json"
    }
    
    public static func getRequest(endPoint: EndPoint, completion: @escaping (Result<Data, GNBError>) -> Void) {
        if let url = URL(string: "\(GNBApi.host)/\(endPoint.rawValue)") {
            let task = URLSession.shared.dataTask(with: url) { (data, resonse, error) in
                if let error = error {
                    completion(.failure(GNBError(.unknown, error.localizedDescription)))
                    return
                }
                guard let data = data else {
                    completion(.failure(GNBError(.dataIsNil)))
                    return
                }
                guard data.count > 0 else {
                    completion(.failure(GNBError(.emptyData)))
                    return
                }
                completion(.success(data))
            }
            task.resume()
        } else {
            completion(.failure(GNBError(.invalidUrl)))
        }
    }
}

class GNBError: Error {
    let type: ErrorType
    let description: String
    
    init(_ type: ErrorType, _ description: String = "") {
        self.type = type
        self.description = description
    }
    enum ErrorType: String {
        case parseFailed
        case invalidUrl
        case emptyData
        case dataIsNil
        case unknown
    }
}
