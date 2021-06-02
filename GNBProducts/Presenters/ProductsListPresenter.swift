import Foundation

class ProductsListPresenter {
    private let apiService: GNBApi
    weak private var productsListViewDelegate: ProductsListViewDelegate?
    
    init() {
        self.apiService = GNBApi()
    }
    
    func setViewDelegate(productsListViewDelegate: ProductsListViewDelegate?) {
        self.productsListViewDelegate = productsListViewDelegate
    }
    
    func getProductsList() {
        productsListViewDelegate?.showLoadingView()
    }
    
    func productSelected(_ product: Product) {
        //get product transactions
    }
    
}
