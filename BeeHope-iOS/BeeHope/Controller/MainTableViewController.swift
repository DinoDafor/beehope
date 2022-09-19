import UIKit

class MainTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        tableView.tableHeaderView = header
    }
}
