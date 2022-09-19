import UIKit

class ApplicationsListController: UITableViewController {
    
    private var applicationModel = ApplicationModel()
    private var initialActivitiIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        setupRefreshControl()
        //applicationModel.deleteAllApplications()
        
        updateData()
    }
    
    private func updateData () {
        applicationModel.getApplicationList { [weak applicationModel] items in
            applicationModel?.fillImages(with: { 
                self.tableView.reloadData()
                self.initialActivitiIndicator?.isHidden = true
                self.refreshControl?.endRefreshing()
            })
        }
    }
    
    private func setupRefreshControl() {
        self.refreshControl?.tintColor = .customLightOrange()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    private func setupActivityIndicator() {
        initialActivitiIndicator = UIActivityIndicatorView(style: .large)
        initialActivitiIndicator?.color = .customLightOrange()
        initialActivitiIndicator?.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
        initialActivitiIndicator?.center = view.center
        initialActivitiIndicator?.startAnimating()
        
        guard let initialActivitiIndicator else {
            return
        }
        
        view.addSubview(initialActivitiIndicator)
    }
    
    @objc func refresh(sender: AnyObject) {        
        updateData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applicationModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "applicationCell", for: indexPath) as! ApplicationCell
        let application = self.applicationModel.items[indexPath.row]
        cell.photo.image = application.photo
        cell.statusLabel.text = application.status
        cell.animalLabel.text = application.animal
        cell.locationLabel.text = application.location
        cell.clipsToBounds = true

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let application = self.applicationModel.items[indexPath.row]
        
        performSegue(withIdentifier: "DetailSegue", sender: application)
        
    }

     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard segue.identifier == "DetailSegue",
         let detailController = segue.destination as? DetailController else {
             return
         }
         
         detailController.application = sender as? Application
     }

}

extension UIColor{
    static func customYellow() -> UIColor {
        return UIColor(red: 0.892, green: 0.745, blue: 0.369, alpha: 1)  
    }
    
    static func customLightOrange() -> UIColor {
        UIColor(red: 0.89, green: 0.427, blue: 0.114, alpha: 1)
    }
    
    static func customDarkOrange() -> UIColor {
        return UIColor(red: 0.6, green: 0.184, blue: 0.012, alpha: 1)
    }

}
