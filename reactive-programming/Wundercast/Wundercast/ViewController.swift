import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  @IBOutlet private var searchCityName: UITextField!
  @IBOutlet private var tempLabel: UILabel!
  @IBOutlet private var humidityLabel: UILabel!
  @IBOutlet private var iconLabel: UILabel!
  @IBOutlet private var cityNameLabel: UILabel!
    @IBOutlet private var switcher: UISwitch!
    
    private var disposeBag = DisposeBag()
    
    lazy var weather = searchCityName.rx
        .text
        .orEmpty
        .flatMapLatest {
        ApiController.shared
            .currentWeather(for: $0)
            .catchAndReturn(.empty)
    }
        .asDriver(onErrorJustReturn: .empty)
    
    private var tempTypeSubject = BehaviorSubject(value: TemperatureUnit.celius)
    
    @IBAction private func switcherValueChanged(sender: UISwitch) {
        let nextUnit = try! tempTypeSubject.value() == .celius ? TemperatureUnit.fahrenheit : .celius
        tempTypeSubject.onNext(nextUnit)
    }
    
    

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    Driver
        .combineLatest(weather, tempTypeSubject.asDriver(onErrorJustReturn: .celius))
        .map { $0.1.valueFromCelius(temp: $0.0.temperature) }
        .drive(tempLabel.rx.text)
        .disposed(by: disposeBag)
    
    weather
        .map { "\($0.humidity)" }
        .drive(humidityLabel.rx.text)
        .disposed(by: disposeBag)
    
    weather
        .map { $0.icon }
        .drive(iconLabel.rx.text)
        .disposed(by: disposeBag)
    
    weather
        .map { $0.cityName }
        .drive(cityNameLabel.rx.text)
        .disposed(by: disposeBag)

    style()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    Appearance.applyBottomLine(to: searchCityName)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Style

  private func style() {
    view.backgroundColor = UIColor.aztec
    searchCityName.attributedPlaceholder = NSAttributedString(string: "City's Name",
                                                              attributes: [.foregroundColor: UIColor.textGrey])
    searchCityName.textColor = UIColor.ufoGreen
    tempLabel.textColor = UIColor.cream
    humidityLabel.textColor = UIColor.cream
    iconLabel.textColor = UIColor.cream
    cityNameLabel.textColor = UIColor.cream
  }
}

extension ViewController {
    enum TemperatureUnit {
        case celius
        case fahrenheit
        
        func valueFromCelius(temp: Int) ->  String {
            switch self {
            case .celius:
                return "\(temp) C"
            case .fahrenheit:
            let fTemp = Double (temp) * 1.8 + 32
                return "\(fTemp) F"
            }
        }
    }
}
