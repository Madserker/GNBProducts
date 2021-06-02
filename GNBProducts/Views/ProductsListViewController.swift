import UIKit


protocol ProductsListViewDelegate: NSObjectProtocol {
    func showLoadingView()
    func hideLoadingView()
    func showProductsList(products: [Product])
    func showProductTransactions(transactions: [Transaction])
}

class ProductsListViewController: UIViewController {

    @IBOutlet weak var productsListTableView: UITableView!
    
    private let productsListPresenter = ProductsListPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsListPresenter.setViewDelegate(productsListViewDelegate: self)
    }
}

extension ProductsListViewController: ProductsListViewDelegate {
    func showProductTransactions(transactions: [Transaction]) {
        //show detail
    }
    
    func showProductsList(products: [Product]) {
        //show products
    }
    
    func showLoadingView() {
        // ..
    }
    
    func hideLoadingView() {
        // ..
    }
}

extension ProductsListViewController: UITableViewDelegate {
    
}

