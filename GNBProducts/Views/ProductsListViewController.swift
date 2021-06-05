import UIKit

protocol ProductsListViewDelegate: NSObjectProtocol {
    func showLoadingView()
    func hideLoadingView()
    func showErrorView()
    func showProductsList(products: [Product])
}

struct ProductsListSection {
    let title: String
    let options: [String]
    var isOpened: Bool
    
    init(title: String, options: [String], isOpened: Bool = false) {
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
}

class ProductsListViewController: UIViewController {

    @IBOutlet weak var productsListTableView: UITableView!
    
    private let productsListPresenter = ProductsListPresenter()
    
    private var sections = [ProductsListSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productsListTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        productsListTableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
        productsListTableView.dataSource = self
        productsListTableView.delegate = self
        
        productsListPresenter.setViewDelegate(productsListViewDelegate: self)
        productsListPresenter.getProductsList()
    }
}

extension ProductsListViewController: ProductsListViewDelegate {
    func showProductsList(products: [Product]) {
        sections = products.map{
            ProductsListSection(
                title: $0.id,
                options: $0.transactions.map {String($0)}
            )
        }
        DispatchQueue.main.async {
            self.productsListTableView.reloadData()
        }
    }
    
    func showLoadingView() {
        // ..
    }
    
    func hideLoadingView() {
        // ..
    }
    
    func showErrorView() {
        // ..
    }
}

extension ProductsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        if section.isOpened {
            return section.options.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell
            cell?.generateCell(productId: sections[indexPath.section].title)
            
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as? TransactionTableViewCell
            cell?.generateCell(amount: "+ " + sections[indexPath.section].options[indexPath.row - 1] + " EUR")
            
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
        tableView.reloadSections([indexPath.section], with: .none)
    }
}
