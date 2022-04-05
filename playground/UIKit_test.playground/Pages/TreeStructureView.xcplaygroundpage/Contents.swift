import UIKit
import PlaygroundSupport

struct Tree<Value: Hashable>: Hashable {
    let value: Value
    var children: [Tree]? = nil
}

let categories: [Tree<String>] = [
    .init(
        value: "Clothing",
        children: [
            .init(value: "Hoodies"),
            .init(value: "Jackets"),
            .init(value: "Joggers"),
            .init(value: "Jumpers"),
            .init(
                value: "Jeans",
                children: [
                    .init(value: "Regular"),
                    .init(value: "Slim")
                ]
            ),
        ]
    ),
    .init(
        value: "Shoes",
        children: [
            .init(value: "Boots"),
            .init(value: "Sliders"),
            .init(value: "Sandals"),
            .init(value: "Trainers"),
        ]
    )
]

class MyViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    private lazy var tableView: UITableView = {
        let v = UITableView(frame: .zero, style: .insetGrouped)
        v.delegate = self
        v.dataSource = self
        return v
    }()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        tableView.isEditing = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].children?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = categories[indexPath.section].children![indexPath.row].value
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedObject = self.headlines[sourceIndexPath.row]
//        headlines.remove(at: sourceIndexPath.row)
//        headlines.insert(movedObject, at: destinationIndexPath.row)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
