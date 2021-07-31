import Foundation
import MapKit
import RxCocoa
import RxSwift

extension MKMapView: HasDelegate {}

class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, DelegateProxyType, MKMapViewDelegate {
    public private(set) weak var mapView: MKMapView?
    public init(mapView: ParentObject) {
        self.mapView = mapView
        super.init(
            parentObject: mapView,
            delegateProxy: RxMKMapViewDelegateProxy.self
        )
    }

    static func registerKnownImplementations() {
        register { RxMKMapViewDelegateProxy(mapView: $0) }
    }
}

public extension Reactive where Base: MKMapView {
    var delegate: DelegateProxy<MKMapView, MKMapViewDelegate> {
        RxMKMapViewDelegateProxy.proxy(for: base)
    }

    var overlay: Binder<MKOverlay> {
        .init(base) { mapView, overlay in
            mapView.removeOverlays(mapView.overlays)
            mapView.addOverlay(overlay)
        }
    }

    var regionDidChangeAnimated: ControlEvent<Bool> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map { ($0[1] as? Bool) ?? false }
        return ControlEvent(events: source)
    }

    func setDelegate(_ delegate: MKMapViewDelegate) -> Disposable {
        RxMKMapViewDelegateProxy.installForwardDelegate(
            delegate,
            retainDelegate: false,
            onProxyForObject: base
        )
    }
}
