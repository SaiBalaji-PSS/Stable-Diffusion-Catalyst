//
//  TextToImageVC.swift
//  StableDiffusion
//
//  Created by Sai Balaji on 25/03/23.
//

import UIKit
import CoreML


let dispatchQueue = DispatchQueue(label: "QueueIdentification2", qos: .background,attributes: .concurrent)

class TextToImageVC: UIViewController {

    @IBOutlet weak var promptBox: UITextField!
    
    @IBOutlet weak var imagesCV: UICollectionView!
    
    var prompt: String = ""
    
    var generatedImage = [CGImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagesCV.delegate = self
        imagesCV.dataSource = self
        imagesCV.register(UINib(nibName: "ImageCell", bundle: nil),forCellWithReuseIdentifier: ImageCell.CELL_ID)
        
    }
    

    @IBAction func generateBtnPressed(_ sender: Any) {
        let mlconfig = MLModelConfiguration()
        mlconfig.computeUnits = .all
        
        if let t = promptBox.text{
            prompt = t
        }
       
        
        do{
            let pipeline = try StableDiffusionPipeline(resourcesAt: URL(string: "file:///Users/saibalaji/Documents/ios/coreml-stable-diffusion-v1-4/split_einsum/compiled/")!,configuration: mlconfig,disableSafety: true,reduceMemory: true)
            
            try pipeline.loadResources()
            var config = StableDiffusionPipeline.Configuration(prompt: prompt)
            
          
            print(config.prompt)
            config.stepCount = 25
            config.seed =  UInt32.random(in: 0...UInt32.max)
            config.imageCount = 15
            config.guidanceScale = 7.5
         //   config.strength = 0.5
            print(config.mode)
      
            dispatchQueue.async {
                do{
                    let images =  try pipeline.generateImages(configuration: config,progressHandler: { progress in
                        print(progress.step)
                        
                        return true
                    })
                    
                    
                    DispatchQueue.main.async {
                        
                        //  self.resultImageView.image = UIImage(cgImage: image)
                        self.generatedImage.removeAll()
                        for i in images{
                            if let i{
                                
                                self.generatedImage.append(i)
                            }
                        }
                        self.imagesCV.reloadData()
                        
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

extension TextToImageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return generatedImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 162.0, height: 149.0)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.CELL_ID, for: indexPath) as? ImageCell{
            cell.update(image: UIImage(cgImage: generatedImage[indexPath.item]))
            return cell
        }
        return UICollectionViewCell()
    }
    
}
