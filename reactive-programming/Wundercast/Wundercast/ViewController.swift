import CoreLocation
import MapKit
import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    @IBOutlet private var searchCityName: UITextField!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var iconLabel: UILabel!
    @IBOutlet private var cityNameLabel: UILabel!
    @IBOutlet private var switcher: UISwitch!

    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var geoLocationButton: UIButton!
    @IBOutlet private var mapButton: UIButton!

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private var disposeBag = DisposeBag()

    private var tempTypeSubject = BehaviorSubject(value: TemperatureUnit.celius)

    private let locationManager = CLLocationManager()

    @IBAction private func switcherValueChanged(sender _: UISwitch) {
        let nextUnit = try! tempTypeSubject.value() == .celius ? TemperatureUnit.fahrenheit : .celius
        tempTypeSubject.onNext(nextUnit)
    }

    @IBAction private func geoLocationButtonTapped() {}

    @IBAction private func mapButtonTapped() {}

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        mapButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.mapView.isHidden.toggle()
            })
            .disposed(by: disposeBag)

        let textInput = searchCityName.rx
            .controlEvent(.editingDidEndOnExit)
            .map { self.searchCityName.text ?? "" }
            .filter { !$0.isEmpty }

        let textSeach = searchCityName.rx.text
            .orEmpty
            .filter { !$0.isEmpty }
            .flatMapLatest {
                ApiController.shared
                    .currentWeather(for: $0)
                    .catchAndReturn(.empty)
            }

        let geoInput = geoLocationButton.rx.tap
            .flatMapLatest { [locationManager] _ in
                locationManager.rx.getCurrentLocation()
            }

        let mapInput = mapView.rx.regionDidChangeAnimated
            .skip(1)
            .map { [mapView] _ in CLLocation(
                latitude: mapView!.centerCoordinate.latitude,
                longitude: mapView!.centerCoordinate.longitude
            ) }

        let geoSearch = Observable.merge(geoInput, mapInput)
            .flatMapLatest {
                ApiController.shared
                    .currentWeather(at: $0.coordinate)
                    .catchAndReturn(.empty)
            }

        let weather = Observable
            .merge(textSeach, geoSearch)
            .asDriver(onErrorJustReturn: .empty)

        weather
            .map { $0.overlay() }
            .drive(mapView.rx.overlay)
            .disposed(by: disposeBag)

        let running = Observable
            .merge(
                mapInput.map { _ in true },
                textInput.map { _ in true },
                geoLocationButton.rx.tap.map { _ in true },
                weather.asObservable().map { _ in false }
            )
            .startWith(true)

        running
            .debug()
            .skip(1)
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

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

        // UI control
        running
            .bind(to: tempLabel.rx.isHidden)
            .disposed(by: disposeBag)

        running
            .bind(to: humidityLabel.rx.isHidden)
            .disposed(by: disposeBag)
        running
            .bind(to: cityNameLabel.rx.isHidden)
            .disposed(by: disposeBag)

        running
            .bind(to: iconLabel.rx.isHidden)
            .disposed(by: disposeBag)

        running
            .bind(to: switcher.rx.isHidden)
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

        func valueFromCelius(temp: Int) -> String {
            switch self {
            case .celius:
                return "\(temp) C"
            case .fahrenheit:
                let fTemp = Double(temp) * 1.8 + 32
                return "\(fTemp) F"
            }
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_: MKMapView,
                 rendererFor overlay: MKOverlay) ->
        MKOverlayRenderer
    {
        guard let overlay = overlay as? ApiController.Weather.Overlay else {
            return MKOverlayRenderer()
        }
        return ApiController.Weather.OverlayView(
            overlay: overlay,
            overlayIcon: overlay.icon
        )
    }
}
