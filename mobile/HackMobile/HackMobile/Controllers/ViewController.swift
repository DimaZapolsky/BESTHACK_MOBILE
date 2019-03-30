//
//  ViewController.swift
//  HackMobile
//
//  Created by Ирина Улитина on 30/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
import Alamofire

extension UIImage {
    func cropped(boundingBox: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}

class ViewController: UIViewController {
    
    private var didCancel: Bool = false
    private var didSelect: Bool = false
    
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
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.lightGray.cgColor
        return iv
    }()
    
    
    fileprivate func getDefaultImagePicker() -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        return imagePicker
    }
    
    
    lazy var button: UIButton = {
        let b = UIButton()
        b.backgroundColor = .tealBlue

        b.clipsToBounds = true
        b.layer.cornerRadius = 10
        b.layer.borderColor = UIColor.gray.cgColor
        b.layer.borderWidth = 0.5
        b.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        b.setTitle("Take Photo", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    /*lazy var recognizeButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .lightTealBlue
        b.clipsToBounds = true
        b.layer.cornerRadius = 10
        b.layer.borderColor = UIColor.gray.cgColor
        b.layer.borderWidth = 0.5
        b.addTarget(self, action: #selector(recognize), for: .touchUpInside)
        b.setTitle("Recognize", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.setTitleColor(.gray, for: .disabled)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isEnabled = false
        return b
    }()*/
    
    lazy var buttonsStack: UIStackView = {
        let view = UIView()
        let sv = UIStackView(arrangedSubviews: [button])
        sv.axis = .horizontal
        sv.spacing = 20
        
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
    @objc func takePhoto(_ sender: UIButton) {
        sender.blink()
        //UNCOMMENT
        let picker = self.getDefaultImagePicker()
        picker.sourceType = UIImagePickerController.SourceType.camera
        
        self.present(picker, animated: true, completion: nil)/*
        let cv = CameraController()
        self.present(cv, animated: true)*/
    }
    
    @objc func recognize(_ sender: UIButton?) {
        sender?.blink()
        let data = self.imageView.image!.pngData()!
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(data, withName: "file", fileName: "file.png", mimeType: "image/png")
        }, to: URL(string: "http://10.128.31.238:3333/")!) { (res) in
            print()
            print()
            print(res)
            switch res {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON(completionHandler: { (resp) in
                        //if (!self.didReselectPhoto) {
                        //Timer.scheduledTimer(withTimeInterval: 8, repeats: false, block: { (_) in
                    
                    if (!self.didCancel) {
                        print("Kek")
                        do {
                            /*if let data = resp.data {
                                let vc = ValidationFormController(card: try JSONDecoder().decode(CodableCard, from: data))
                            }*/
                            let vc = ValidationFormController(card: CodableCard(holderName: "Obama", bankName: "BABang", expDate: Date(), cardNumber: "1234 5678 9012", color: nil))
                            self.navigationController?.pushViewController(vc, animated: true)

                        } catch let err {
                            print(err)
                            fatalError()
                        }
                        //let vc = ConfirmationTableViewController(credential: ["Name":"Obama", "expires":"02/20", "bank":"Alpha bank"])

                    } else {
                        print("Cancel")
                    }
                    self.didSelect = false
                    self.didCancel = false
                        //})
                    
                })
                /*upload.responseJSON { response in
                    //response.data
                    print(response.result.value)
                    var mydict = response.result.value as! [String : Any]
                    print(response.result.value as! [String : Any])
                    var arr = [[String : String]]()
                    arr = mydict["results"] as! [[String : String]]
                    mydict["results"] = arr
                    print(mydict)
                    if let JSON = response.data {
                        print("Response : ",JSON)
                        do {
                            
                        } catch {
                            print("ERROR WHILE DECODING")
                        }
                    }
                }*/
            default:
                print("ERROR!!!")
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Add Card"
        self.view.addSubview(imageView)
        self.view.addSubview(buttonsStack)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            //imageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.0 / 1.0, constant: 0),
            buttonsStack.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20),
            buttonsStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            buttonsStack.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4, constant: -10),
            buttonsStack.heightAnchor.constraint(equalToConstant: 50),
            //button.widthAnchor.constraint(equalTo: buttonsStack.widthAnchor, multiplier: 0.43, constant: 0),
            //recognizeButton.widthAnchor.constraint(equalTo: buttonsStack.widthAnchor, multiplier: 0.43, constant: 0)
            ])
        
        
        /*if let tesseract = G8Tesseract(language: "digits") {
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
        }*/
    }


}

extension ViewController: UINavigationControllerDelegate {
    
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        self.imageView.image = chosenImage
        if didSelect {
            didCancel = true
        } else {
            didSelect = true
        }
        self.recognize(nil)
        /*let orientation = CGImagePropertyOrientation(rawValue: UInt32(chosenImage.imageOrientation.rawValue))!
        
        let request = [self.rectangleDetectionRequest]
        
        let imageRequestHandler = VNImageRequestHandler(cgImage: chosenImage.cgImage!,
                                                        orientation: orientation,
                                                        options: [:])
        
        // Send the requests to the request handler.
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform(request)
            } catch let error as NSError {
                print("Failed to perform image request: \(error)")
                //self.presentAlert("Image Request Failed", error: error)
                return
            }
        }
        */
        
        //recognizeButton.isEnabled = true
        //recognizeButton.backgroundColor = UIColor.tealBlue
        //self.toggleEditingButtons(true)
        //to be sure that ImagePickerController will be dismissed
        defer {
            dismiss(animated: true, completion: nil)
        }
    }
}

