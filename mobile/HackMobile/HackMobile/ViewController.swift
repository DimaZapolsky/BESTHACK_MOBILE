//
//  ViewController.swift
//  HackMobile
//
//  Created by Ирина Улитина on 30/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController {

    func DrawOnImage(startingImage: UIImage, box: CGRect) -> UIImage {
        
        // Create a context of the starting image size and set it as the current one
        let width = startingImage.size.width
        let height = startingImage.size.height
        
        //let heigth = start
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        // Draw a red line
        /*context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.red.cgColor)
        context.move(to: CGPoint(x: startx, y: starty))
        context.addLine(to: CGPoint(x: secondx, y: secondy))
        context.strokePath()*/
        
        // Draw a transparent green Circle
        context.setStrokeColor(UIColor.green.cgColor)
        context.setAlpha(0.5)
        context.setLineWidth(2.0)
        //context.addRect(in: CGRect(x: startx, y: starty, width: box.width*width, height: box.height*height))
        context.addRect(CGRect(x: box.origin.x * width, y: box.origin.y * height, width: box.width * width, height: box.height * height))
        context.drawPath(using: .stroke) // or .fillStroke if need filling
        
        // Save the context as a new UIImage
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return myImage!
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        if let tesseract = G8Tesseract(language: "ocr+mcr") {
            //
            tesseract.engineMode = .cubeOnly
            
            // 3
            tesseract.pageSegmentationMode = .sparseText
            tesseract.maximumRecognitionTime = 60 * 24 * 60

            // 4
            tesseract.image = UIImage(named: "card")!
            
            // 5
            tesseract.recognize()
            var newImage =  UIImage(named: "card")!
            //print(tesseract.recognizedBlocks(by: G8PageIteratorLevel.textline))
            for each in tesseract.recognizedBlocks(by: G8PageIteratorLevel.textline)! {
                var block = each as! G8RecognizedBlock
                print(block.boundingBox)
                newImage = DrawOnImage(startingImage: newImage, box: block.boundingBox)
                print(block.confidence)
                print(block.text)
                print("")
            }
            imageView.image = newImage
            // 6
            print(tesseract.recognizedText)
        }
    }


}

