import UIKit

protocol ProductsListViewDelegate: NSObjectProtocol {
    func showLoadingView()
    func hideLoadingView()
    func showErrorView()
    func showProductsList(products: [Product])
}

struct ProductsListSection {
    let title: String
    let options: [Double]
    var isOpened: Bool
    
    init(title: String, options: [Double], isOpened: Bool = false) {
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
}

class ProductsListViewController: UIViewController {

    @IBOutlet weak var productsListTableView: UITableView!
    
    private let productsListPresenter = ProductsListPresenter()
    
    private var sections = [ProductsListSection]()
    private var spinner = UIActivityIndicatorView(style: .large)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSpinner()
        setupTableView()
        
        productsListPresenter.setViewDelegate(productsListViewDelegate: self)
        productsListPresenter.getProductsList()
    }
    
    private func setupSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupTableView() {
        productsListTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        productsListTableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
        productsListTableView.dataSource = self
        productsListTableView.delegate = self
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        productsListPresenter.getProductsList()
    }
}

extension ProductsListViewController: ProductsListViewDelegate {
    func showProductsList(products: [Product]) {
        sections = products.map{
            ProductsListSection(
                title: $0.id,
                options: $0.transactions
            )
        }
        DispatchQueue.main.async {
            self.productsListTableView.reloadData()
        }
    }
    
    func showLoadingView() {
        // ..
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func hideLoadingView() {
        // ..
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
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
            return section.options.count + 2
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

            if indexPath.row - 1 == sections[indexPath.section].options.count {
                var total: Double = 0.0
                for amount in sections[indexPath.section].options {
                    total += amount
                }
                let roundedTotal = Double(round(100*total)/100)
                cell?.generateCell(amount: "TOTAL: \(roundedTotal) \(CurrencyService.selectedCurrency)")
            } else {
                let roundedAmount = Double(round(100*sections[indexPath.section].options[indexPath.row - 1])/100)
                cell?.generateCell(amount: "+ \(roundedAmount) \(CurrencyService.selectedCurrency)")
            }
            
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
        tableView.reloadSections([indexPath.section], with: .none)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else if indexPath.row - 1 == sections[indexPath.section].options.count {
            return 45
        } else {
            return 20
        }
    }
}
