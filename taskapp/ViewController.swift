import UIKit
import Foundation
import RealmSwift   // ←追加

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()  // Realmインスタンスを取得する
    var searchBar: UISearchBar!
    var searchBarUserText: String!      //ユーザーがserchbar利用時に検索に使用した言葉
    
    // DB内のタスクが格納されるリスト。
    // 日付近い順\順でソート：降順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        setupSearchBar()
        print ("動作チェック_メインViewDidload")
    }
    
    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // segue で画面遷移するに呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            task.date = Date()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            inputViewController.task = task
        }
        print ("動作チェック_画面遷移メイン→タスク詳細")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //////////// MARK: UISearchBarプロトコルのメソッド////////////
    func setupSearchBar() {
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "タイトルで探す"
            searchBar.tintColor = UIColor.gray
            searchBar.keyboardType = UIKeyboardType.default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
            print("setupserchbar動作")
        }
    }
    
    ////////////MARK: - UISearchBar Delegate methods////////////
    // 編集が開始されたら、キャンセルボタンを有効にする
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    // キャンセルボタンが押されたらキャンセルボタンを無効にしてフォーカスを外す
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    //
   func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String){
        searchBarUserText = searchText
        print ("動作チェック_検索バーテキスト\(searchBarUserText)")
    }
    
    ////////////MARK: UITableViewDataSourceプロトコルのメソッド////////////
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("動作チェック_データ数（＝セルの数）のチェックする関数")
        return taskArray.count  // ←追加する
        
    }
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Cellに値を設定する.indexPathで何番目のセルなのかを管理
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        cell.textLabel?.text = task.category
        
        // Description: DateFormatter()関数を格納している変数.各cellに記述する内容の呼び出しに使用する
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        //dateStringを新規で定義。string(from: task.date)でtask
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        //セル内に記入したカテゴリーの表示
        //let categoryString:String = formatter.string(from: task.category)
        //cell.Categorytitle?.text = categoryString
        
        print ("動作チェック_各セル内の値を設定し引数として渡す関数");
        
        return cell
    }
    
    ////////////MARK: UITableViewDelegateプロトコルのメソッド////////////
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
        return .delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データベースから削除する  // ←以降追加する
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        print ("動作チェック_07")

    }
}

