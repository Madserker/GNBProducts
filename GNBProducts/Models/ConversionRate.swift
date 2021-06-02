import Foundation

class ConversionRate {
    public var from: String
    public var to: String
    public var rate: Double
    
    init(from: String, to: String, rate: Double) {
        self.from = from
        self.to = to
        self.rate = rate
    }
}
