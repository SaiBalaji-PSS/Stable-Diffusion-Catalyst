//
//  ViewController.swift
//  StableDiffusion
//
//  Created by Sai Balaji on 25/03/23.
//

import UIKit
import StableDiffusion
import CoreML

class ViewController: UIViewController {

    
    @IBOutlet weak var startingImageView: UIImageView!
    @IBOutlet weak var promtBox: UITextField!
    @IBOutlet weak var resultImageView: UIImageView!
    
    var startingimage: CGImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func importBtnPressed(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeJPEG),String(kUTTypePNG)], in: .import)
           documentPicker.delegate = self
           documentPicker.allowsMultipleSelection = false
           documentPicker.modalPresentationStyle = .fullScreen
           present(documentPicker, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func btnPressed(_ sender: Any) {
        StableDiffusionService.shared.mlConfig.computeUnits = .all
        StableDiffusionService.shared.modelPath = "file:///Users/saibalaji/Documents/ios/coreml-stable-diffusion-v1-4/split_einsum/compiled/"

        StableDiffusionService.shared.imageToImage(prompt: promtBox.text, startingImage: self.startingimage,computeUnits: .all) { error , image in
            DispatchQueue.main.async {
                if let error{
                    print(error)
                }
                if let image{
                    self.resultImageView.image = UIImage(cgImage: image)
                }
            }
           
        }
    }
}

extension ViewController: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if controller.documentPickerMode == .import{
            if let url = urls.first{
                if let image = UIImage(contentsOfFile: url.path){
                    
                    self.startingimage = image.cgImage
                    self.startingImageView.image = image
                    controller.dismiss(animated: true)
                }
            }
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
    
    
}






