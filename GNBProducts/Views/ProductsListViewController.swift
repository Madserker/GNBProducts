import UIKit

protocol ProductsListViewDelegate: NSObjectProtocol {
    func showLoadingView()
    func hideLoadingView()
    func showErrorView(error: GNBError)
    func showProductsList(products: [Product])
}

struct ProductsListSection {
    let title: String
    let transactions: [Double]
    var isOpened: Bool
    
    init(title: String, transactions: [Double], isOpened: Bool = false) {
        self.title = title
        self.transactions = transactions
        self.isOpened = isOpened
    }
}

class ProductsListViewController: UIViewController {

    @IBOutlet weak var productsListTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var productsListTitleLabel: UILabel!
    
    private let productsListPresenter = ProductsListPresenter()
    
    private var sections = [ProductsListSection]()
    private var spinner = UIActivityIndicatorView(style: .large)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSpinner()
        setupTableView()
        
        productsListPresenter.setViewDelegate(productsListViewDelegate: self)
        productsListPresenter.getProductsList()
    }
    
    private func setupUI() {
        errorLabel.isHidden = true
        errorLabel.font = UIFont.systemFont(ofSize: 28)
        errorLabel.textColor = .gray
        
        productsListTitleLabel.font = UIFont.systemFont(ofSize: 32)
        productsListTitleLabel.textColor = .black
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
                transactions: $0.transactions
            )
        }
        DispatchQueue.main.async {
            self.productsListTableView.isHidden = false
            self.errorLabel.isHidden = true

            self.productsListTableView.reloadData()
        }
    }
    
    func showLoadingView() {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
    func showErrorView(error: GNBError) {
        DispatchQueue.main.async {
            self.productsListTableView.isHidden = true
            self.errorLabel.isHidden = false
            
            switch error.type {
                case .emptyData:
                    self.errorLabel.text = "No hemos encontrado ningun producto."
                default:
                    self.errorLabel.text = "Algo ha ido mal."
            }
        }
    }
}

extension ProductsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        if section.isOpened {
            return section.transactions.count + 2
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

            if indexPath.row - 1 == sections[indexPath.section].transactions.count {
                var total: Double = 0.0
                for amount in sections[indexPath.section].transactions {
                    total += amount
                }
                let roundedTotal = Double(round(100*total)/100)
                cell?.generateCell(amount: "TOTAL: \(roundedTotal) \(CurrencyService.selectedCurrency)", finalCell: true)
            } else {
                let roundedAmount = Double(round(100*sections[indexPath.section].transactions[indexPath.row - 1])/100)
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
        } else if indexPath.row - 1 == sections[indexPath.section].transactions.count {
            return 45
        } else {
            return 20
        }
    }
}
