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
            
            print(x_value)
            print(y_value)
            print(score_value)
            print(description)
            
            if score_value < 0.7 { return }


            let text = SCNText(string: description, extrusionDepth: 1)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.green
            text.materials = [material]

            let node = SCNNode()
            node.position = SCNVector3(-x_value/1000, -y_value/1000, 0)
//            node.position = SCNVector3(0, 0.02, -0.1)
            node.scale = SCNVector3(0.01, 0.01, 0.01)

            node.geometry = text

            sceneView.scene.rootNode.addChildNode(node)
            sceneView.automaticallyUpdatesLighting = true
            
            perform(#selector(dismissText(node:)), with: nil, afterDelay: 0.1)
        }
        
    }
    
    @objc func dismissText(node: SCNNode) {
        node.removeFromParentNode()
    }
    
    
    private var detectionOverlay: CALayer! = nil
    let imageView = UIImageView()
    var image: UIImage?
    var sceneView = ARSCNView()
    let googleModel = GoogleModel()
    
    // Vision parts
    private var requests = [VNRequest]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // sceneView
        sceneView.delegate = self
        view.addSubview(sceneView)
        sceneView.frame = view.frame
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        
        
        // observer
        NotificationCenter.default.addObserver(self, selector: #selector(displayARText(_:)), name: Notification.Name("displayARText"), object: nil)

        // timer
        let timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { (timer) in
            guard let captureImage = self.image else {return}
//            let pixbuff : CVPixelBuffer? = (self.sceneView.session.currentFrame?.capturedImage)
//            if pixbuff == nil { return }
//            let ciImage = CIImage(cvPixelBuffer: pixbuff!)
//            let context = CIContext()
//            guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
//            let captureImage = UIImage(cgImage: cgImage)
            self.googleModel.postImage(image: captureImage)
        }
        
//         imageView for testing captured frames
//        view.addSubview(imageView)
//        imageView.frame = CGRect(x: 100, y: 300, width: 300, height: 300)
//        imageView.contentMode = .scaleAspectFit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        perform(#selector(delaySceneView), with: nil, afterDelay: 1.5)
    }
    
    @objc func delaySceneView() {
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.sceneView.session.pause()
    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        DispatchQueue.main.async {
//            self.imageView.image = self.image?.rotate(radians: .pi/2)
//        }
//    }
    
    override func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("diddrop")
    }

    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("didoutput")
//        self.sceneView.session.pause()
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return  }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)

        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return  }
        image = UIImage(cgImage: cgImage)
        DispatchQueue.main.async {
            self.imageView.image = self.image?.rotate(radians: .pi/2)
        }
        
//        perform(#selector(blockingSceneView), with: nil, afterDelay: 0.0001)

    }
    
    @objc func blockingSceneView() {
        print("block")
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.session.run(configuration)
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
