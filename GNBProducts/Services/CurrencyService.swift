import Foundation

class CurrencyService {
    public static var selectedCurrency: String = "EUR"
    
    public static func parseTransactionAmount(amount: Double, currencyFrom: String, conversionRates: [ConversionRate]) -> Double {
        var found = false
        var usedConversions = [ConversionRate]()
        var currentCurrency = currencyFrom
        var parsedAmount = amount

        while(!found) {
            for conversion in conversionRates {
                if conversion.from == currentCurrency && conversion.to == selectedCurrency {
                    usedConversions.append(conversion)
                    parsedAmount *= conversion.rate
                    found = true
                }
            }
            if (!found) {
                for conversion in conversionRates {
                    if conversion.from == currentCurrency && usedConversions.filter({$0.from == conversion.from && $0.to == conversion.to}).first == nil {
                        usedConversions.append(conversion)
                        parsedAmount *= conversion.rate
                        currentCurrency = conversion.to
                    }
                }
            }
        }
        return parsedAmount
    }
}
