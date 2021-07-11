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
  private var imageCache = [Int]()

  override func viewDidLoad() {
    super.viewDidLoad()

    let imageObservable = images.share()
    imageObservable
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] listImage in
        guard let weakSelf = self, let preview = weakSelf.imagePreview else { return }
        preview.image = listImage.collage(size: preview.frame.size)
        
        self?.updateNavigationIcon()
      })
      .disposed(by: bag)
    
    imageObservable
      .subscribe(onNext: { [weak self] listImage in
        self?.updateUI(photos: listImage)
      })
      .disposed(by: bag)

  }
  
  @IBAction func actionClear() {
    images.accept([])
    imageCache.removeAll()
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
    
    let newPhoto = photosViewController.selectedImage.share()

    newPhoto
      .filter({ newImage in
        newImage.size.width > newImage.size.height
      })
      .filter({ [weak self] newImage in
        guard let strongSelf = self else { return false }
        let dataCount = newImage.pngData()?.count ?? 0
        if strongSelf.imageCache.contains(dataCount) {
          return false
        } else {
          strongSelf.imageCache.append(dataCount)
          return true
        }
      })
      .take(while: { [weak self] newImage in
        guard let strongSelf = self else { return false }
        return strongSelf.images.value.count <= 5
      })
      .subscribe(
        onNext: { [images] image in
          let newListImage = images.value + [image]
          images.accept(newListImage)
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
  
  private func updateNavigationIcon() {
    let icon = imagePreview.image?
      .scaled(CGSize(width: 22, height: 22))
      .withRenderingMode(.alwaysOriginal)
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: icon,
      style: .done,
      target: nil,
      action: nil
    )
  }
}
