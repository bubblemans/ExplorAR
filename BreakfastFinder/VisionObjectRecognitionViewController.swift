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
            
            if let description = description {
                shopApi.getShop(shop: description)
            }
            
            print(x_value)
            print(y_value)
            print(score_value)
            print(description)
            
            if score_value < 0.75 { return }
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleMoreInfo), name: Notification.Name("moreInfo"), object: nil)
        }
    }
    
    @objc func handleMoreInfo() {
        print("handleMoreInfo")
        print(moreInfo)
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
//        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        
        
        // observer
        NotificationCenter.default.addObserver(self, selector: #selector(displayARText(_:)), name: Notification.Name("displayARText"), object: nil)

        // timer
//        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
////            guard let captureImage = self.image else {return}
//            let pixbuff : CVPixelBuffer? = (self.sceneView.session.currentFrame?.capturedImage)
//            if pixbuff == nil { return }
//            let ciImage = CIImage(cvPixelBuffer: pixbuff!)
//            let context = CIContext()
//            guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
//            let captureImage = UIImage(cgImage: cgImage)
//            self.googleModel.postImage(image: captureImage)
//        }
        
//         imageView for testing captured frames
//        view.addSubview(imageView)
//        imageView.frame = view.frame
//        imageView.contentMode = .scaleAspectFit
        
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
        print("handleScan")
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
//        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
//        self.session.startRunning()
//        imageView.alpha = 1
//        perform(#selector(blockCapture), with: nil, afterDelay: 2.0)
//        perform(#selector(delaySceneView), with: nil, afterDelay: 2.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.session.run(configuration)
//        perform(#selector(delaySceneView), with: nil, afterDelay: 2.0)
    }
    
    @objc func delaySceneView() {
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.sceneView.session.pause()
    }

    override func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("diddrop")
    }

    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("didoutput")
//        self.sceneView.session.pause()
//        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return  }
//        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
//
//        let context = CIContext()
//        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return  }
//        image = UIImage(cgImage: cgImage)
//        DispatchQueue.main.async {
//            self.imageView.image = self.image?.rotate(radians: .pi/2)
//        }
        
//        perform(#selector(blockingSceneView), with: nil, afterDelay: 0.0001)

    }
    
    @objc func blockingSceneView() {
        print("block")
        let configuration = ARWorldTrackingConfiguration()
        configuration.isAutoFocusEnabled = true
        configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
//        imageView.alpha = 0
    }

    override func setupAVCapture() {
        super.setupAVCapture()
        startCaptureSession()
    }
    
    func createTextNode(string: String)->SCNNode {
        let text = SCNText(string: string, extrusionDepth: 0.1)
        let textNode = SCNNode(geometry: text)
        
        textNode.scale = SCNVector3(1, 1, 1)
        textNode.position = SCNVector3(1, 1, 0)
        return textNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            node.addChildNode(self.createTextNode(string: "KFC"))
            print("renderer")
        }
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}
