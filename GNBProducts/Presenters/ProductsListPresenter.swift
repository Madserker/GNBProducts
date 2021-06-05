import Foundation

class ProductsListPresenter {
    private let apiService: ApiService
    weak private var productsListViewDelegate: ProductsListViewDelegate?
    
    init() {
        self.apiService = ApiService()
    }
    
    func setViewDelegate(productsListViewDelegate: ProductsListViewDelegate?) {
        self.productsListViewDelegate = productsListViewDelegate
    }
    
    func getProductsList() {
        var productsList: [Product] = []
        productsListViewDelegate?.showLoadingView()
        apiService.fetchTransactions() { result in
            switch result {
            case .success(let data):
                self.getConversionRates() { conversionRates in
                    if (conversionRates.count > 0) {
                        for transaction in data {
                            let currentProduct = productsList.filter({$0.id == transaction.productId}).first
                            let amount = CurrencyService.parseTransactionAmount(amount: transaction.amount, currencyFrom: transaction.currency, conversionRates: conversionRates)
                            if let safeCurrentProduct = currentProduct {
                                safeCurrentProduct.transactions.append(amount)
                            } else {
                                productsList.append(Product(id: transaction.productId, transactions: [amount]))
                            }
                        }
                        self.productsListViewDelegate?.hideLoadingView()
                        self.productsListViewDelegate?.showProductsList(products: productsList)
                    } else {
                        self.productsListViewDelegate?.hideLoadingView()
                        self.productsListViewDelegate?.showErrorView()
                    }
                }
            case .failure(let error):
                switch error.type {
                case .emptyData:
                    self.productsListViewDelegate?.hideLoadingView()
                    self.productsListViewDelegate?.showErrorView()
                default:
                    self.productsListViewDelegate?.hideLoadingView()
                    self.productsListViewDelegate?.showErrorView()
                }
            }
        }
    }
    
    private func getConversionRates(completion: @escaping ([ConversionRate]) -> Void) {
        apiService.fetchConversionRates() { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure:
                completion([])
            }
        }
    }
}
