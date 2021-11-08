//
//  ViewController.swift
//  UIImageDownsampling
//
//  Created by Alper Öztürk on 8.11.2021.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var compressionQualityPickerView: UIPickerView!
    @IBOutlet weak var compressionPickerView: UIPickerView!
    @IBOutlet weak var downsampledPreviewImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    @IBAction func pickImage(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func initUI(){
        compressionQualityPickerView.tag = 1
        compressionQualityPickerView.delegate = self
        compressionQualityPickerView.dataSource = self
        compressionQualityPickerView.selectRow(2, inComponent: 0, animated: true)
        
        compressionPickerView.delegate = self
        compressionPickerView.dataSource = self
        compressionPickerView.selectRow(8, inComponent: 0, animated: true)
        
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
    }
    
    private func updateUI(_ downsampledSize:String, _ image:UIImage){
        resultLabel.text = "File Size: " + downsampledSize + "mb"
        downsampledPreviewImageView.image = image
    }

}

extension MainVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true, completion: nil)
       
        if let rawImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            var level:CGFloat = 10.0
            
            if let strongness = NumberFormatter().number(from: AppConst.strongness) {
                level = CGFloat(truncating: strongness)
            }
            
            let downsampledImageSize = CGSize(width: rawImage.size.width / level , height: rawImage.size.height / level)
            guard let downsampledImage = rawImage.scaleImage(toSize: downsampledImageSize) else { return }
        
            let downsampledFileSize = String(downsampledImage.sizeInMB)
            updateUI(downsampledFileSize, downsampledImage)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
}


extension MainVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return AppConst.compressionQualities[row]
        }
        else
        {
            return AppConst.compressionLevels[row]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return AppConst.compressionQualities.count
        }
        else
        {
            return AppConst.compressionLevels.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            var quality: CGInterpolationQuality = .high
            let qualityChoice = AppConst.compressionQualities[pickerView.selectedRow(inComponent: 0)]
            
            if qualityChoice == "low"
            {
                quality = .low
            }
            else if qualityChoice == "medium"
            {
                quality = .medium
            }
            if qualityChoice == "high"
            {
                quality = .high
            }
            
            AppConst.quality = quality
        }
        else
        {
            let pickerValue = AppConst.compressionLevels[pickerView.selectedRow(inComponent: 0)]
            
            if pickerValue == "Untouched PNG Data"
            {
                AppConst.strongness = "1.0"
            }
            else
            {
                AppConst.strongness = pickerValue
            }
        }
    }
}
