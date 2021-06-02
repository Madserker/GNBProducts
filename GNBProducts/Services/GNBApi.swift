import Foundation

class GNBApi {
    public static let host = "http://quiet-stone2094.herokuapp.com"
    
    enum EndPoint: String {
        case conversionRates = "rates.json"
        case transactions = "transactions.json"
    }
    
    public static func getRequest(endPoint: EndPoint, completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: "\(GNBApi.host)/\(endPoint.rawValue)") {
            let task = URLSession.shared.dataTask(with: url) { (data, resonse, error) in
                if let error = error {
                    completion(.failure(error))
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
    
    init(_ type: ErrorType) {
        self.type = type
    }
    enum ErrorType {
        case parseFailed
        case invalidUrl
        case emptyData
        case dataIsNil
        case unknown
    }
}
