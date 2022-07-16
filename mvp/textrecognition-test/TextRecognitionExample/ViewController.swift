//
//  Copyright (c) 2021 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import MLImage
import MLKit
import UIKit

import SnapKit
import SwifterSwift
import WebKit

/// Main view controller class.
@objc(ViewController)
class ViewController: UIViewController, UINavigationControllerDelegate {
    /// A string holding current results from detection.
    var resultsText = ""

    /// An overlay view that displays detection annotations.
    private lazy var annotationOverlayView: UIView = {
        precondition(isViewLoaded)
        let annotationOverlayView = UIView(frame: .zero)
        annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        annotationOverlayView.clipsToBounds = true
        return annotationOverlayView
    }()

    /// An image picker for accessing the photo library or camera.
    var imagePicker = UIImagePickerController()

    // Image counter.
    var currentImage = 0

    // MARK: - IBOutlets

    @IBOutlet fileprivate var imageView: UIImageView!
    @IBOutlet fileprivate var photoCameraButton: UIBarButtonItem!
    @IBOutlet fileprivate var videoCameraButton: UIBarButtonItem!
    @IBOutlet var detectButton: UIBarButtonItem!

    private var webView: WKWebView?
//    {
//        let config = WKWebViewConfiguration()
//        config.selectionGranularity = .dynamic
//        let uc = config.userContentController
//
    ////        uc.addUserScript(WKUserScript.fromFile("", type: <#T##String#>))
    ////
    ////        // Rangy
    ////        uc.addUserScript(RangyScript.core())
    ////        uc.addUserScript(RangyScript.classapplier())
    ////        uc.addUserScript(RangyScript.highlighter())
    ////        uc.addUserScript(RangyScript.selectionsaverestore())
    ////        uc.addUserScript(RangyScript.textrange())
    ////
    ////        // Marker
    ////        uc.addUserScript(MarkerScript.css())
    ////        uc.addUserScript(MarkerScript.jsScript())
    ////
    ////        uc.add(self.marker, name: MarkerScript.Handler.serialize.rawValue)
    ////        uc.add(self.marker, name: MarkerScript.Handler.erase.rawValue)
//
//        let v = WKWebView(frame: .zero, configuration: config)
//        v.scrollView.backgroundColor = .clear
//        v.backgroundColor = .clear
//        v.isOpaque = false
//
//        return v
//    }()

    private func processDataForWeb(_ textLines: [TextLine]) {
        func makeLineNodeInjectionScript(text: String, frame: CGRect) -> WKUserScript {
            let script = """
                javascript:(function() {
                const lineNode = document.createElement('div');
                lineNode.setAttribute(
                  'class',
                  'line selectionEnable',
                );
                lineNode.innerText = "\(text)"
                lineNode.style.left = "\(frame.minX)px"
                lineNode.style.top = "\(frame.minY)px"
                lineNode.style.width = "\(frame.width)px"
                lineNode.style.height = "\(frame.height)px"
                var parent = document.querySelector("#container");
                parent.appendChild(lineNode)})()
            """
            return WKUserScript(
                source: script,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: false
            )
        }

        guard let imageBase64 = imageView.image?.pngBase64String() else {
            return
        }

        let lineNodeInjectionScripts = textLines.map { line -> (String, CGRect) in
            let transformedRect = line.frame.applying(transformMatrix())
            return (line.text, transformedRect)
        }
        .map { text, frame in
            makeLineNodeInjectionScript(text: text, frame: frame)
        }

        func makeImageBase64InjectionScript(_ imageBase64: String) -> WKUserScript {
            let script = """
                javascript:(function() {
                const image = document.createElement('img');
                image.setAttribute(
                  'class',
                  'selectionDisable',
                );
                image.setAttribute(
                  'src',
                  'data:image/png;base64, \(imageBase64)',
                );
                var parent = document.querySelector("#container");
                parent.appendChild(image)})()
            """
            return WKUserScript(
                source: script,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: false
            )
        }

        let webView: WKWebView = {
            let config = WKWebViewConfiguration()
            config.selectionGranularity = .dynamic
            let uc = config.userContentController
            uc.addUserScript(makeImageBase64InjectionScript(imageBase64))
            uc.addUserScript(.fromFile("style", type: "css"))

            lineNodeInjectionScripts.forEach { script in
                uc.addUserScript(script)
            }
            //
            //        // Rangy
            //        uc.addUserScript(RangyScript.core())
            //        uc.addUserScript(RangyScript.classapplier())
            //        uc.addUserScript(RangyScript.highlighter())
            //        uc.addUserScript(RangyScript.selectionsaverestore())
            //        uc.addUserScript(RangyScript.textrange())
            //
            //        // Marker
            //        uc.addUserScript(MarkerScript.css())
            //        uc.addUserScript(MarkerScript.jsScript())
            //
            //        uc.add(self.marker, name: MarkerScript.Handler.serialize.rawValue)
            //        uc.add(self.marker, name: MarkerScript.Handler.erase.rawValue)

            let v = WKWebView(frame: .zero, configuration: config)
            v.scrollView.backgroundColor = .clear
            v.backgroundColor = .clear
            v.isOpaque = false

            return v
        }()

        let path = Bundle.main.path(forResource: "index", ofType: "html")!
        let htmlString = try! String(contentsOfFile: path)
        webView.loadHTMLString(htmlString, baseURL: nil)

        self.webView?.removeFromSuperview()
        self.webView = webView

        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalTo(imageView)
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: Constants.images[currentImage])
        imageView.addSubview(annotationOverlayView)
        NSLayoutConstraint.activate([
            annotationOverlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
            annotationOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            annotationOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            annotationOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])

//        let path = Bundle.main.path(forResource: "index", ofType: "html")!
//        let url = URL(fileURLWithPath: path)
//        webView.loadFileURL(url, allowingReadAccessTo: url)

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

        let isCameraAvailable =
            UIImagePickerController.isCameraDeviceAvailable(.front)
                || UIImagePickerController.isCameraDeviceAvailable(.rear)
        if isCameraAvailable {
            // `CameraViewController` uses `AVCaptureDevice.DiscoverySession` which is only supported for
            // iOS 10 or newer.
            if #available(iOS 10.0, *) {
                videoCameraButton.isEnabled = true
            }
        } else {
            photoCameraButton.isEnabled = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - IBActions

    @IBAction func detect(_: Any) {
        clearResults()
        detectTextOnDevice(image: imageView.image)
    }

    @IBAction func openPhotoLibrary(_: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }

    @IBAction func openCamera(_: Any) {
        guard
            UIImagePickerController.isCameraDeviceAvailable(.front)
            || UIImagePickerController
            .isCameraDeviceAvailable(.rear)
        else {
            return
        }
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }

    // MARK: - Private

    /// Removes the detection annotations from the annotation overlay view.
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }

    /// Clears the results text view and removes any frames that are visible.
    private func clearResults() {
        removeDetectionAnnotations()
        resultsText = ""
    }

    private func showResults() {
        let resultsAlertController = UIAlertController(
            title: "Detection Results",
            message: nil,
            preferredStyle: .actionSheet
        )
        resultsAlertController.addAction(
            UIAlertAction(title: "OK", style: .destructive) { _ in
                resultsAlertController.dismiss(animated: true, completion: nil)
            }
        )
        resultsAlertController.message = resultsText
        resultsAlertController.popoverPresentationController?.barButtonItem = detectButton
        resultsAlertController.popoverPresentationController?.sourceView = view
        present(resultsAlertController, animated: true, completion: nil)
        print(resultsText)
    }

    /// Updates the image view with a scaled version of the given image.
    private func updateImageView(with image: UIImage) {
        let orientation = UIApplication.shared.statusBarOrientation
        var scaledImageWidth: CGFloat = 0.0
        var scaledImageHeight: CGFloat = 0.0
        switch orientation {
        case .portrait, .portraitUpsideDown, .unknown:
            scaledImageWidth = imageView.bounds.size.width
            scaledImageHeight = image.size.height * scaledImageWidth / image.size.width
        case .landscapeLeft, .landscapeRight:
            scaledImageWidth = image.size.width * scaledImageHeight / image.size.height
            scaledImageHeight = imageView.bounds.size.height
        @unknown default:
            fatalError()
        }
        weak var weakSelf = self
        DispatchQueue.global(qos: .userInitiated).async {
            // Scale image while maintaining aspect ratio so it displays better in the UIImageView.
            var scaledImage = image.scaledImage(
                with: CGSize(width: scaledImageWidth, height: scaledImageHeight)
            )
            scaledImage = scaledImage ?? image
            guard let finalImage = scaledImage else { return }
            DispatchQueue.main.async {
                weakSelf?.imageView.image = finalImage
            }
        }
    }

    private func transformMatrix() -> CGAffineTransform {
        guard let image = imageView.image else { return CGAffineTransform() }
        let imageViewWidth = imageView.frame.size.width
        let imageViewHeight = imageView.frame.size.height
        let imageWidth = image.size.width
        let imageHeight = image.size.height

        let imageViewAspectRatio = imageViewWidth / imageViewHeight
        let imageAspectRatio = imageWidth / imageHeight
        let scale =
            (imageViewAspectRatio > imageAspectRatio)
                ? imageViewHeight / imageHeight : imageViewWidth / imageWidth

        // Image view's `contentMode` is `scaleAspectFit`, which scales the image to fit the size of the
        // image view by maintaining the aspect ratio. Multiple by `scale` to get image's original size.
        let scaledImageWidth = imageWidth * scale
        let scaledImageHeight = imageHeight * scale
        let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
        let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)

        var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
        transform = transform.scaledBy(x: scale, y: scale)
        return transform
    }

    private func pointFrom(_ visionPoint: VisionPoint) -> CGPoint {
        return CGPoint(x: visionPoint.x, y: visionPoint.y)
    }

    private func process(_ visionImage: VisionImage, with textRecognizer: TextRecognizer?) {
        weak var weakSelf = self
        textRecognizer?.process(visionImage) { text, error in
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            guard error == nil, let text = text else {
                let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
                strongSelf.resultsText = "Text recognizer failed with error: \(errorString)"
                strongSelf.showResults()
                return
            }

            // Blocks.
            for block in text.blocks {
                let transformedRect = block.frame.applying(strongSelf.transformMatrix())
                UIUtilities.addRectangle(
                    transformedRect,
                    to: strongSelf.annotationOverlayView,
                    color: UIColor.purple
                )

                // Lines.
                for line in block.lines {
                    let transformedRect = line.frame.applying(strongSelf.transformMatrix())
                    UIUtilities.addRectangle(
                        transformedRect,
                        to: strongSelf.annotationOverlayView,
                        color: UIColor.orange
                    )

                    print("transformedRect", transformedRect)

                    // Elements.
                    for element in line.elements {
                        let transformedRect = element.frame.applying(strongSelf.transformMatrix())
                        UIUtilities.addRectangle(
                            transformedRect,
                            to: strongSelf.annotationOverlayView,
                            color: UIColor.green
                        )
                        let label = UILabel(frame: transformedRect)
                        label.text = element.text
                        label.adjustsFontSizeToFitWidth = true
                        strongSelf.annotationOverlayView.addSubview(label)
                    }
                }
            }

            let textLines = text.blocks.flatMap(\.lines)

            strongSelf.processDataForWeb(textLines)

            strongSelf.resultsText += "\(text.text)\n"
            strongSelf.showResults()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        clearResults()
        if let pickedImage =
            info[
                convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)
            ]
            as? UIImage {
            updateImageView(with: pickedImage)
        }
        dismiss(animated: true)
    }
}

/// Extension of ViewController for On-Device detection.
extension ViewController {
    // MARK: - Detection

    /// Detects text on the specified image and draws a frame around the recognized text using the text recognizer.
    ///
    /// - Parameter image: The image.
    private func detectTextOnDevice(image: UIImage?) {
        guard let image = image else { return }
        let textRecognizer = TextRecognizer.textRecognizer()

        // Initialize a `VisionImage` object with the given `UIImage`.
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation

        resultsText += "Running Text Recognition...\n"
        process(visionImage, with: textRecognizer)
    }
}

// MARK: - Enums

private enum Constants {
    static let images = ["image_has_text.jpg"]
    static let detectionNoResultsMessage = "No results returned."
    static let failedToDetectObjectsMessage = "Failed to detect objects in image."
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(
    _ input: [UIImagePickerController.InfoKey: Any]
) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey)
    -> String {
    return input.rawValue
}