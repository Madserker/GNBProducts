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
    
    func getProductsList(completion: @escaping ([Product]) -> Void) {
        var productsList: [Product] = []
        productsListViewDelegate?.showLoadingView()
        apiService.fetchTransactions() { result in
            switch result {
            case .success(let data):
                for transaction in data {
                   print(transaction)
                }
            case .failure(let error):
                print(error)
            }
            self.productsListViewDelegate?.hideLoadingView()
        }
    }
    
    func productSelected(_ product: Product) {
        //get product transactions
    }
    
}
