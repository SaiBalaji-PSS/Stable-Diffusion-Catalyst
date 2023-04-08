//
//  StableDiffusionService.swift
//  StableDiffusion
//
//  Created by Sai Balaji on 07/04/23.
//

import Foundation
import CoreML
import UIKit


class StableDiffusionService{
    let dispatchQueue = DispatchQueue(label: "QueueIdentification2", qos: .background,attributes: .concurrent)
    static var shared = StableDiffusionService()
    let mlConfig = MLModelConfiguration()
    
    var modelPath: String?
    var generatedImage = [CGImage]()
    
    
    
    func textToImageGenerator(prompt: String?,computeUnits: MLComputeUnits,onCompletion:@escaping(Error?,[CGImage]?)->(Void)){
        
        guard let modelPath else{ return }
        guard let prompt else{return }
        print(mlConfig.computeUnits)
        mlConfig.computeUnits = computeUnits
        do{
            let pipeline = try StableDiffusionPipeline(resourcesAt: URL(string: "\(modelPath)")!,configuration: mlConfig,disableSafety: true,reduceMemory: true)
        
            try pipeline.loadResources()
            var config = StableDiffusionPipeline.Configuration(prompt: prompt)
            print(config.prompt)
            config.stepCount = 25
            config.seed =  UInt32.random(in: 0...UInt32.max)
            config.imageCount = 15
            config.guidanceScale = 7.5
            //config.strength = 0.5
            print(config.mode)
      
            dispatchQueue.async {
                do{
                    let images =  try pipeline.generateImages(configuration: config,progressHandler: { progress in
                        print(progress.step)
                        
                        return true
                    })
                        
                        self.generatedImage.removeAll()
                        for i in images{
                            if let i{
                                
                                self.generatedImage.append(i)
                            }
                        }
                      
                    onCompletion(nil,self.generatedImage)
                    
                    
                }
                catch{
                    print(error)
                    onCompletion(error,nil)
                }
            }
            
          
        }
        catch{
            print(error)
            onCompletion(error,nil)
        }
    }
    func imageToImage(prompt: String?,startingImage: CGImage?,computeUnits: MLComputeUnits,onCompletion:@escaping(Error?,CGImage?)->(Void)){
        guard let modelPath else{ return }
        guard let prompt else{return }
        print(mlConfig.computeUnits)
        mlConfig.computeUnits = computeUnits
        do{
            let pipeline = try StableDiffusionPipeline(resourcesAt: URL(string: modelPath)!,configuration: mlConfig,disableSafety: true,reduceMemory: true)
            
            try pipeline.loadResources()
            var config = StableDiffusionPipeline.Configuration(prompt: prompt)
            
            if let startingImage{
                config.startingImage = startingImage
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
           // let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .userInteractive)
          
            dispatchQueue.async {
                do{
                    let image =  try pipeline.generateImages(configuration: config,progressHandler: { progress in
                        
                        print(progress.step)
                        
                        
                        
                        return true
                    }).first!
//                    DispatchQueue.main.async {
//                        if let image = image{
//                            self.resultImageView.image = UIImage(cgImage: image)
//                        }
//                    }
                    onCompletion(nil,image)
                }
                catch{
                    print(error)
                    onCompletion(error,nil)
                }
            }
           
          
        }
        
        catch{
            print(error)
            onCompletion(error,nil)
        }
    }
}
