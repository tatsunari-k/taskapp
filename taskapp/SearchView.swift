import UIKit

class aViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let PPAP:[String] = ["PPAP", "I have a pen", "I have a apple", "Uh! Apple-Pen!", "I have a pen", "I have pineapple", "Uh! Pineapple-Pen!", "Apple-Pen, Pineapple-Pen", "Uh! Pen-Pineapple-Apple-Pen", "Pen-Pineapple-Apple-Pen"]
    var searchResults:[String] = []
    var tableView: UITableView!
    var searchController = UISearchController()
    
    ///////UITableViewとsearchvirwの設定//////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: self.view.frame.width, height: self.view.frame.height))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return PPAP.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        if searchController.isActive {
            cell.textLabel!.text = "\(searchResults[indexPath.row])"
        } else {
            cell.textLabel!.text = "\(PPAP[indexPath.row])"
        }
        
        return cell
    }
    
    // 文字が入力される度に呼ばれる
    func updateSearchResults(for searchController: UISearchController) {
        self.searchResults = PPAP.filter{
            // 大文字と小文字を区別せずに検索
            $0.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        self.tableView.reloadData()
    }
    
}

//import Foundation
//import UIKit
//
//class SearchView: UIViewController, UISearchBarDelegate {
//
//    var searchBar: UISearchBar!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupSearchBar()
//        print("setupserchbar動作")
//    }
//
//    func setupSearchBar() {
//        if let navigationBarFrame = navigationController?.navigationBar.bounds {
//            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
//            searchBar.delegate = self
//            searchBar.placeholder = "タイトルで探す"
//            searchBar.tintColor = UIColor.gray
//            searchBar.keyboardType = UIKeyboardType.default
//            navigationItem.titleView = searchBar
//            navigationItem.titleView?.frame = searchBar.frame
//            self.searchBar = searchBar
//            print("setupserchbar動作")
//        }
//    }
//
//    // MARK: - UISearchBar Delegate methods
//    // 編集が開始されたら、キャンセルボタンを有効にする
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        searchBar.showsCancelButton = true
//        return true
//    }
//
//    // キャンセルボタンが押されたらキャンセルボタンを無効にしてフォーカスを外す
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
//        searchBar.resignFirstResponder()
//    }
//}
//
//
