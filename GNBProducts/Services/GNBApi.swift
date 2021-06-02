import Foundation

class GNBApi {
    public static let host = "http://quiet-stone2094.herokuapp.com"
    
    enum EndPoint: String {
        case conversionRates = "rates.json"
        case transactions = "transactions.json"
    }
    
    public static func getRequest(endPoint: EndPoint, completion: @escaping (Data) -> Void) {
        let url = URL(string: "\(GNBApi.host)/\(endPoint.rawValue)")!
        let task = URLSession.shared.dataTask(with: url) { (data, resonse, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            completion(data)
        }
        task.resume()
    }
}
