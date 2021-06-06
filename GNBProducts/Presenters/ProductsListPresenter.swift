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
                self.apiService.fetchConversionRates() { conversionsResult in
                    switch conversionsResult {
                        case .success(let conversionRates):
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
                        case .failure(let error):
                            self.productsListViewDelegate?.hideLoadingView()
                            self.productsListViewDelegate?.showErrorView(error: error)
                    }
                }
            case .failure(let error):
                self.productsListViewDelegate?.hideLoadingView()
                self.productsListViewDelegate?.showErrorView(error: error)
            }
        }
    }
}
