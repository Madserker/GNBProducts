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
        productsListViewDelegate?.showLoadingView()
        apiService.fetchTransactions() { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                error
                print(error)
            }
            self.productsListViewDelegate?.hideLoadingView()
        }
    }
    
    func productSelected(_ product: Product) {
        //get product transactions
    }
    
}
