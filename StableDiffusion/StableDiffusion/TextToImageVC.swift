//
//  TextToImageVC.swift
//  StableDiffusion
//
//  Created by Sai Balaji on 25/03/23.
//

import UIKit
import CoreML


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
        StableDiffusionService.shared.modelPath = "file:///Users/saibalaji/Documents/ios/coreml-stable-diffusion-v1-4/split_einsum/compiled/"
        StableDiffusionService.shared.textToImageGenerator(prompt: promptBox.text,computeUnits: .all) { error , images  in
            DispatchQueue.main.async {
                if let error{
                    print(error)
                }
                if let images{
                    self.generatedImage = images
                    self.imagesCV.reloadData()
                }
            }
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
