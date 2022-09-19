import UIKit

class CreateApplicationModalController: UITableViewController {
    
    private let applicationModel = ApplicationModel()
    private var shouldLoadPhoto: Bool = false
    
    @IBOutlet var animalTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var locationTextFIeld: UITextField!
    @IBOutlet var uploadPhotoButton: UIButton!
    @IBOutlet var photoImageView: UIImageView!
    
    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadPhotoButton.layer.borderWidth = 2
        uploadPhotoButton.layer.borderColor = UIColor.customLightOrange().cgColor
        
        photoImageView.layer.cornerRadius = photoImageView.bounds.height / 2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        animalTextField.delegate = self
        descriptionTextField.delegate = self
        locationTextFIeld.delegate = self
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @IBAction func uploadPhotoTapped(_ sender: UIButton) {
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        guard let imagePicker = imagePicker else {
            return
        }
        
        imagePicker.present(from: sender)
    }
    
    
    @IBAction func createApplicationTapped(_ sender: Any) {
        sendApplication()
    }
    
    
    @IBAction func CancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func sendApplication() {
        guard 
        animalTextField.text?.count ?? 0 > 0,
        locationTextFIeld.text?.count ?? 0 > 0 
        else {
            showWarning()
            return
        }
        
        if let photo = self.photoImageView.image, self.shouldLoadPhoto {
            FileDownloader.uploadImageToImgur(image: photo, completion: { link, error in
                guard let link else { return }
                DispatchQueue.main.async {
                    guard let application = Application(animal: self.animalTextField.text, description: self.descriptionTextField.text, location: self.locationTextFIeld.text, photoLink: link) else { return }
                    self.applicationModel.sendToServer(application: application)
                    self.dismiss(animated: true)
                }
            })
        }  else {
            guard let application = Application(animal: self.animalTextField.text, description: self.descriptionTextField.text, location: self.locationTextFIeld.text, photoLink: nil) else { return }
            self.applicationModel.sendToServer(application: application)
            self.dismiss(animated: true)
        }
    }
    
    private func showWarning() {
        let alert = UIAlertController(title: "Ошибка", message: "Необходимо ввести название животного и координаты", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CreateApplicationModalController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.photoImageView.image = image
        self.shouldLoadPhoto = true
    }
}

extension CreateApplicationModalController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}
