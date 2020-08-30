import UIKit
import PlaygroundSupport

class MyViewController : UIViewController, UIPopoverPresentationControllerDelegate {
    let fakeData: [String] = (0..<10).map { "Row \($0)" }
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .gray

        let tableFrame = CGRect(x: 40, y: 100, width: 300, height: 420)
        let tableView = UITableView(frame: tableFrame)
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        self.view = view
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension MyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // setup popover view
        let popoverView = UIViewController()
        popoverView.view.backgroundColor = .green
        popoverView.modalPresentationStyle = .popover
        popoverView.preferredContentSize = CGSize(width: 100, height: 50)
        
        let popover = popoverView.popoverPresentationController
        popover?.delegate = self
        
        // (1)
        popover?.sourceView = view
        
        let cellRect = tableView.rectForRow(at: indexPath)
        
        // convert step
//        let convertedRect = view.convert(cellRect, from: tableView)
        // or
        let convertedRect = tableView.convert(cellRect, to: view)
        let sourceRect = convertedRect.insetBy(dx: 0, dy: -10)
        
        // (2)
        popover?.sourceRect = sourceRect
        
        popover?.permittedArrowDirections = .down

        self.present(popoverView, animated: true, completion: nil)
    }
}

extension MyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let data = fakeData[indexPath.row]
        cell.textLabel?.text = data
        return cell
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
