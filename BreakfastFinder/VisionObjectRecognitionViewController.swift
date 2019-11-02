/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Contains the object recognition view controller for the Breakfast Finder.
*/

import UIKit
import AVFoundation
import Vision
import ARKit
import SceneKit

var moreInfo: String?
class VisionObjectRecognitionViewController: ViewController, ARSCNViewDelegate {
    @objc func displayARText(_ notification: Notification) {
        if notification.userInfo?["userInfo"] as? [String: Any] != nil {
            let userInfo = notification.userInfo?["userInfo"] as? [String: Any]
            let description = userInfo?["description"] as? String
            let x = userInfo?["x"] as? Double
            guard let x_value = x else {return}
            
            let y = userInfo?["y"] as? Double
            guard let y_value = y else {return}
            
            let score = userInfo?["score"] as? Double
            guard let score_value = score else {return}
            
//            print(x_value)
//            print(y_value)
//            print(score_value)
//            print(description)
            
            if score_value < 0.7 { return }
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleMoreInfo), name: Notification.Name("moreInfo"), object: nil)

            if let description = description {
                shopApi.getShop(shop: description)
            }
        }
    }
    
    @objc func handleMoreInfo() {
        let text = SCNText(string: moreInfo, extrusionDepth: 1)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.orange
        text.materials = [material]
        text.flatness = 0
        text.font = .boldSystemFont(ofSize: 10)

        let node = SCNNode()
        let width = Double(view.frame.width)
        let height = Double(view.frame.height)
        node.position = SCNVector3(-0.5, -1, -1)
        node.scale = SCNVector3(0.01, 0.01, 0.01)

        node.geometry = text
 
        sceneView.scene.rootNode.addChildNode(node)
        sceneView.automaticallyUpdatesLighting = true
    }
    
    private var detectionOverlay: CALayer! = nil
    var image: UIImage?
    var sceneView = ARSCNView()
    let googleModel = GoogleModel()
    let shopApi = ShopApi()
    let scanButton = UIButton()
    
    // Vision parts
    private var requests = [VNRequest]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // sceneView
        sceneView.delegate = self
        view.addSubview(sceneView)
        sceneView.frame = view.frame
        
        // observer
        NotificationCenter.default.addObserver(self, selector: #selector(displayARText(_:)), name: Notification.Name("displayARText"), object: nil)

        // scanButton
        view.addSubview(scanButton)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scanButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        scanButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        scanButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        scanButton.setTitle("Scan", for: .normal)
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.backgroundColor = .black
        scanButton.layer.cornerRadius = 10
        scanButton.addTarget(self, action: #selector(handleScan), for: .touchUpInside)
    }
    
    @objc func handleScan() {
        for node in sceneView.scene.rootNode.childNodes {
            node.removeFromParentNode()
        }
        let pixbuff : CVPixelBuffer? = (self.sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        let captureImage = UIImage(cgImage: cgImage)
        self.googleModel.postImage(image: captureImage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.sceneView.session.pause()
    }

    override func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    }

    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return  }
//        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
//
//        let context = CIContext()
//        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return  }
//        image = UIImage(cgImage: cgImage)
//        DispatchQueue.main.async {
//            self.imageView.image = self.image?.rotate(radians: .pi/2)
//        }

    }

    override func setupAVCapture() {
        super.setupAVCapture()
        startCaptureSession()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    }
}

