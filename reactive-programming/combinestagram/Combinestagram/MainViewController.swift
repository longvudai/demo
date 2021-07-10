import UIKit
import RxSwift
import RxRelay

class MainViewController: UIViewController {

  @IBOutlet weak var imagePreview: UIImageView!
  @IBOutlet weak var buttonClear: UIButton!
  @IBOutlet weak var buttonSave: UIButton!
  @IBOutlet weak var itemAdd: UIBarButtonItem!
  
  private let bag = DisposeBag()
  private let images = BehaviorRelay<[UIImage]>(value: [])

  override func viewDidLoad() {
    super.viewDidLoad()

    images
      .subscribe(onNext: { [weak self] listImage in
        guard let weakSelf = self, let preview = weakSelf.imagePreview else { return }
        weakSelf.updateUI(photos: listImage)
        preview.image = listImage.collage(size: preview.frame.size)
      })
      .disposed(by: bag)
  }
  
  @IBAction func actionClear() {
    images.accept([])
  }

  @IBAction func actionSave() {
    if let image = imagePreview.image {
      PhotoWriter.save(image: image)
        .subscribe(onSuccess: { [weak self] identifier in
          self?.showMessage(identifier)
          self?.actionClear()
        }, onFailure: { [weak self] error in
          self?.showMessage("Error", description: error.localizedDescription)
        })
        .disposed(by: bag)
    }
  }

  @IBAction func actionAdd() {
    let photosViewController = storyboard!.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
    photosViewController.selectedImage
      .subscribe(onNext: { [images] image in
        let newListImage = images.value + [image]
        images.accept(newListImage)
      }
      , onCompleted: {
        print("Completed")
      }
      ,onDisposed: {
        print("disposed")
      })
      .disposed(by: bag)

    navigationController!.pushViewController(photosViewController, animated: true)
  }

  func showMessage(_ title: String, description: String? = nil) {
    alert(title, description: description).subscribe().disposed(by: bag)
  }
  
  private func updateUI(photos: [UIImage]) {
    buttonSave.isEnabled = photos.count > 0 && photos.count % 2 ==
  0
    buttonClear.isEnabled = photos.count > 0
    itemAdd.isEnabled = photos.count < 6
    title = photos.count > 0 ? "\(photos.count) photos" :
  "Collage"
  }
}
