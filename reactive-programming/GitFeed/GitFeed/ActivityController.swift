import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SwiftyJSON

class ActivityController: UITableViewController {
    private let repo = "ReactiveX/RxSwift"
    private let eventsFileURL = cachedFileURL("events.json")
    private let lastModifierFileURL = cachedFileURL("lastModifier.txt")

    private let events = BehaviorRelay<[Event]>(value: [])
    private let lastModifierSubject = BehaviorRelay<String?>(value: nil)
    private let bag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = repo

    self.refreshControl = UIRefreshControl()
    let refreshControl = self.refreshControl!

    refreshControl.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
    refreshControl.tintColor = UIColor.darkGray
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    
    let decoder = JSONDecoder()
    if
        let data = try? Data(contentsOf: eventsFileURL),
        let events = try? decoder.decode([Event].self, from: data) {
        self.events.accept(events)
    }
    
    if
        let lastModifierData = try? Data(contentsOf: lastModifierFileURL),
        let lastModifier = String(data: lastModifierData, encoding: .utf8) {
        lastModifierSubject.accept(lastModifier)
    }

    refresh()
  }

  @objc func refresh() {
    DispatchQueue.global(qos: .default).async { [weak self] in
      guard let self = self else { return }
      self.fetchEvents(repo: self.repo)
    }
  }

  func fetchEvents(repo: String) {
    let response = Observable
        .from(["https://api.github.com/search/repositories?q=language:swift&per_page=5"])
        .compactMap { URL(string: $0) }
        .flatMap { URLSession.shared.rx.json(url: $0) }
        .flatMap { jsonData -> Observable<String> in
            let json = JSON.init(jsonData)
            let items = json["items"].array ?? []
            let repos = items.compactMap {
                return try? $0["full_name"].string
            }
            return Observable.from(repos)
        }
        .compactMap { URL(string: "https://api.github.com/repos/\($0)/events?per_page=5") }
        .map { [weak self] in
            var request = URLRequest(url: $0)
            if let lastModifier = self?.lastModifierSubject.value {
                request.addValue(lastModifier, forHTTPHeaderField: "Last-Modified")
            }
            return request
        }
        .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
            return URLSession.shared.rx.response(request: request)
        }
        .share(replay: 1, scope: .whileConnected)

    response
        .filter { 200..<300 ~= $0.response.statusCode }
        .compactMap { try? JSONDecoder().decode([Event].self, from: $0.data) }
        .subscribe { [weak self] events in
            self?.processEvents(events)
        }
        .disposed(by: bag)

    response
        .filter { 200..<400 ~= $0.response.statusCode }
        .flatMap { (response, _) -> Observable<String> in
            if let lastModifier = response.allHeaderFields["Last-Modified"] as? String {
                return Observable.just(lastModifier)
            } else {
                return Observable.empty()
            }
        }
        .subscribe(onNext: { [weak self] lastModifier in
            guard let self = self else {
                return
            }
            self.lastModifierSubject.accept(lastModifier)
            try? lastModifier.write(to: self.lastModifierFileURL, atomically: true, encoding: .utf8)
        })
        .disposed(by: bag)

  }
  
  func processEvents(_ newEvents: [Event]) {
    print(newEvents.count)
    var events = newEvents + events.value
    if events.count > 50 {
        events = Array(events.prefix(50))
    }
    self.events.accept(events)
    DispatchQueue.main.async {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    let encoder = JSONEncoder()
    if let eventsData = try? encoder.encode(events) {
        try? eventsData.write(to: eventsFileURL, options: .atomicWrite)
    }
  }

  // MARK: - Table Data Source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.value.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let event = events.value[indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
    cell.textLabel?.text = event.actor.name
    cell.detailTextLabel?.text = event.repo.name + ", " + event.action.replacingOccurrences(of: "Event", with: "").lowercased()
    cell.imageView?.kf.setImage(with: event.actor.avatar, placeholder: UIImage(named: "blank-avatar"))
    return cell
  }
}
