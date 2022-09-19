import UIKit

class ApplicationCell: UITableViewCell {
    
    @IBOutlet var backgroundCellView: UIView!
    @IBOutlet var photo: UIImageView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var animalLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundCellView.layer.borderColor = UIColor.customYellow().cgColor
        backgroundCellView.layer.borderWidth = 2
        backgroundCellView.layer.cornerRadius = 12
        
        photo.layer.cornerRadius = photo.bounds.height / 2
        
    }
    
    public static func placeHolderPhoto() -> UIImage {
        var placeholderPhoto = UIImage(systemName: "pawprint.circle")
        placeholderPhoto = placeholderPhoto?.withTintColor(.customLightOrange(), renderingMode: .alwaysOriginal)
        return placeholderPhoto!
    }

}
