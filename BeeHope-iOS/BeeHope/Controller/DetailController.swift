import UIKit

class DetailController: UITableViewController {
    
    public var application: Application?
    @IBOutlet var photo: UIImageView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var applicationView: UIView!
    @IBOutlet var animalLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        applicationView.layer.cornerRadius = 12
        applicationView.layer.borderWidth = 2
        applicationView.layer.borderColor = UIColor.customYellow().cgColor
        
        photo.layer.cornerRadius = 22
        
        guard let application else {
            return
        }
        
        photo.image = application.photo
        statusLabel.text = application.status
        animalLabel.text = application.animal
        locationLabel.text = application.location 
        descriptionLabel.text = application.description
    }
}
