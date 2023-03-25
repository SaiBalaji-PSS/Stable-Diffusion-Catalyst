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
    var prompt = "Mario in chennai"
    var startingimage: CGImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   
//        let imagePath = URL(filePath: "/Users/saibalaji/Documents/ios/sunflower.jpeg")
//        do{
//            let imagedata = try Data(contentsOf: imagePath)
//            if let image = UIImage(data: imagedata){
//                self.resultImageView.image = image
//                if let i = image.cgImage{
//                    self.startingimage = i
//                }
//            }
//
//
//        }
//        catch{
//            print(error)
//        }
//        
        
         
        
        
    }
    
    
    
    @IBAction func importBtnPressed(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeJPEG),String(kUTTypePNG)], in: .import)
           documentPicker.delegate = self
           documentPicker.allowsMultipleSelection = false
           documentPicker.modalPresentationStyle = .fullScreen
           present(documentPicker, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func btnPressed(_ sender: Any) {
        let mlconfig = MLModelConfiguration()
        mlconfig.computeUnits = .all
        
        if let t = promtBox.text{
            prompt = t
        }
       
        
        do{
            let pipeline = try StableDiffusionPipeline(resourcesAt: URL(string: "file:///Users/saibalaji/Documents/ios/coreml-stable-diffusion-v1-4/split_einsum/compiled/")!,configuration: mlconfig,disableSafety: true,reduceMemory: true)
            
            try pipeline.loadResources()
            var config = StableDiffusionPipeline.Configuration(prompt: prompt)
            
            if let startingimage{
                config.startingImage = startingimage
            }
            if config.startingImage == nil{
                print("EMPTY")
            }
            print(config.prompt)
            config.stepCount = 25
            config.seed =  UInt32.random(in: 0...UInt32.max)
            config.imageCount = 5
            config.guidanceScale = 7.5
            config.strength = 0.5
            print(config.mode)
            let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .userInteractive)
          
            dispatchQueue.async {
                do{
                    let image =  try pipeline.generateImages(configuration: config,progressHandler: { progress in
                        
                        print(progress.step)
                        
                        
                        
                        return true
                    }).first!
                    DispatchQueue.main.async {
                        if let image = image{
                            self.resultImageView.image = UIImage(cgImage: image)
                        }
                    }
                }
                catch{
                    print(error)
                }
            }
           
          
        }
        
        catch{
            print(error)
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


