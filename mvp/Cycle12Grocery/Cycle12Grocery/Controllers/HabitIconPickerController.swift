//
//  HabitIconPickerController.swift
//  Cycle12Grocery
//
//  Created by longvu on 8/19/21.
//

import UIKit

protocol HabitIconPickerControllerDelegate: AnyObject {
    func habitIconPickerController(_ controlelr: HabitIconPickerController, color: UIColor, iconName: String)
}

class HabitIconPickerController: UIViewController {
    // MARK: - UI properties

    private lazy var horizontalSepator: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.separator
        return v
    }()

    private lazy var colorSelectorCollectionView: ColorSelectorCollectionView = {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(60), heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
            return section
        }
        let v = ColorSelectorCollectionView(frame: .zero, collectionViewLayout: layout)
        v.register(ColorSelectorCollectionView.Cell.self, forCellWithReuseIdentifier: "color-cell")
        v.delegate = self
        v.dataSource = self

        v.alwaysBounceVertical = false

        v.backgroundColor = Colors.background
        v.allowsMultipleSelection = false

        return v
    }()

    private lazy var habitIconCollectionView: HabitIconCollectionView = {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnv in
            let itemWidth: CGFloat = 60
            let itemSpacing: CGFloat = 12
            let numberOfItem = max(floor(layoutEnv.container.effectiveContentSize.width / (itemWidth + itemSpacing)), 0)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(72))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)

            let totalItemSpacing = CGFloat(numberOfItem) * itemSpacing
            let sectionInset = (layoutEnv.container.effectiveContentSize.width - totalItemSpacing - itemWidth * numberOfItem) / 2
            section.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
            return section
        }
        let v = HabitIconCollectionView(frame: .zero, collectionViewLayout: layout)
        v.register(HabitIconCollectionView.Cell.self, forCellWithReuseIdentifier: "icon-cell")
        v.delegate = self
        v.dataSource = self

        v.backgroundColor = Colors.secondaryBackground

        return v
    }()

    private lazy var colorPickerButton: UIButton = {
        let v = UIButton()
        let image = UIImage(named: ImageAsset.habitEditColorPicker.rawValue)
        v.setImage(image, for: .normal)
        v.imageView?.tintColor = Colors.labelSecondary
        v.addTarget(self, action: #selector(colorPickerButtonTapped), for: .touchUpInside)
        return v
    }()

    private lazy var verticalSeparator: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.JournalColor.verticalSeparatorDateSelector
        return v
    }()

    // MARK: - Properties

    private lazy var colors: [UIColor] = [
        HabitIconPickerController.cyan,
        HabitIconPickerController.green,
        HabitIconPickerController.red,
        HabitIconPickerController.black,
        HabitIconPickerController.blue,
        HabitIconPickerController.orange,
    ]

    private lazy var iconNames: [String] = {
        [
            ImageAsset.icon1.rawValue,
            ImageAsset.icon2.rawValue,
            ImageAsset.icon3.rawValue,
            ImageAsset.icon4.rawValue,
            ImageAsset.icon5.rawValue,
            ImageAsset.icon6.rawValue,
            ImageAsset.icon7.rawValue,
            ImageAsset.icon8.rawValue,
            ImageAsset.icon9.rawValue,
            ImageAsset.icon9.rawValue,
            ImageAsset.icon10.rawValue,
            ImageAsset.icon11.rawValue,
            ImageAsset.icon12.rawValue,
            ImageAsset.icon13.rawValue,
            ImageAsset.icon14.rawValue,
            ImageAsset.icon15.rawValue,
            ImageAsset.icon16.rawValue,
            ImageAsset.icon17.rawValue,
            ImageAsset.icon18.rawValue,
            ImageAsset.icon19.rawValue,
            ImageAsset.icon20.rawValue,
            ImageAsset.icon21.rawValue,
            ImageAsset.icon22.rawValue,
            ImageAsset.icon23.rawValue,
            ImageAsset.icon24.rawValue,
            ImageAsset.icon25.rawValue,
            ImageAsset.icon26.rawValue,
            ImageAsset.icon27.rawValue,
            ImageAsset.icon28.rawValue,
            ImageAsset.icon29.rawValue,
            ImageAsset.icon30.rawValue,
            ImageAsset.icon31.rawValue,
            ImageAsset.icon32.rawValue,
            ImageAsset.icon33.rawValue,
            ImageAsset.icon34.rawValue,
            ImageAsset.icon35.rawValue,
            ImageAsset.icon36.rawValue,
            ImageAsset.icon37.rawValue,
            ImageAsset.icon38.rawValue,
            ImageAsset.icon39.rawValue,
            ImageAsset.icon40.rawValue,
            ImageAsset.icon41.rawValue,
            ImageAsset.icon42.rawValue,
            ImageAsset.icon43.rawValue,
            ImageAsset.icon44.rawValue,
            ImageAsset.icon45.rawValue,
            ImageAsset.icon46.rawValue,
            ImageAsset.icon47.rawValue,
            ImageAsset.icon48.rawValue,
            ImageAsset.icon49.rawValue,
            ImageAsset.icon50.rawValue,
            ImageAsset.icon51.rawValue,
            ImageAsset.icon52.rawValue,
            ImageAsset.icon53.rawValue,
            ImageAsset.icon54.rawValue,
            ImageAsset.icon55.rawValue,
            ImageAsset.icon56.rawValue,
            ImageAsset.icon57.rawValue,
            ImageAsset.icon58.rawValue,
            ImageAsset.icon59.rawValue,
            ImageAsset.icon60.rawValue,
            ImageAsset.icon61.rawValue,
            ImageAsset.icon62.rawValue,
            ImageAsset.icon63.rawValue,
            ImageAsset.icon64.rawValue,
            ImageAsset.icon65.rawValue,
            ImageAsset.icon66.rawValue,
            ImageAsset.icon67.rawValue,
            ImageAsset.icon68.rawValue,
            ImageAsset.icon69.rawValue,
            ImageAsset.icon70.rawValue,
            ImageAsset.icon71.rawValue,
            ImageAsset.icon72.rawValue,
            ImageAsset.icon73.rawValue,
            ImageAsset.icon74.rawValue,
            ImageAsset.icon75.rawValue,
            ImageAsset.icon76.rawValue,
            ImageAsset.icon77.rawValue,
            ImageAsset.icon78.rawValue,
            ImageAsset.icon79.rawValue,
            ImageAsset.icon80.rawValue,
            ImageAsset.icon81.rawValue,
            ImageAsset.icon82.rawValue,
            ImageAsset.icon83.rawValue,
            ImageAsset.icon84.rawValue,
            ImageAsset.icon85.rawValue,
            ImageAsset.icon86.rawValue,
            ImageAsset.icon87.rawValue,
            ImageAsset.icon88.rawValue,
            ImageAsset.icon89.rawValue,
        ]
    }()

    private var selectedColor: UIColor? {
        didSet {
            habitIconCollectionView.reloadData()
        }
    }

    private var selectedIconName: String?

    weak var delegate: HabitIconPickerControllerDelegate?

    // MARK: - Initialization

    init(selectedColor: UIColor?, selectedIconName: String?) {
        self.selectedIconName = selectedIconName
        self.selectedColor = selectedColor ?? HabitIconPickerController.cyan

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup navigation
        title = "Select Icon"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )

        view.backgroundColor = Colors.background

        setupView()
        setupConstraits()
    }

    private func setupView() {
        var views = [colorSelectorCollectionView, horizontalSepator, habitIconCollectionView]
        if #available(iOS 14.0, *) {
            views.append(contentsOf: [verticalSeparator, colorPickerButton])
        }
        views.forEach { view.addSubview($0) }
    }

    private func setupConstraits() {
        colorSelectorCollectionView.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide)
            if #available(iOS 14.0, *) {
                $0.trailing.equalTo(verticalSeparator.snp.leading)
            } else {
                $0.trailing.equalTo(view.safeAreaLayoutGuide)
            }

            $0.height.equalTo(60)
        }

        if #available(iOS 14.0, *) {
            verticalSeparator.snp.makeConstraints {
                $0.centerY.equalTo(colorSelectorCollectionView)
                $0.trailing.equalTo(colorPickerButton.snp.leading)
                $0.width.equalTo(1)
                $0.height.equalTo(34)
            }

            colorPickerButton.snp.makeConstraints {
                $0.width.height.equalTo(54)
                $0.trailing.equalToSuperview()
                $0.centerY.equalTo(colorSelectorCollectionView)
            }
        }

        horizontalSepator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(colorSelectorCollectionView.snp.bottom)
            $0.height.equalTo(1)
        }

        habitIconCollectionView.snp.makeConstraints {
            $0.top.equalTo(horizontalSepator.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    @objc private func colorPickerButtonTapped() {
        if #available(iOS 14.0, *) {
            let c = UIColorPickerViewController()
            c.delegate = self
            present(c, animated: true, completion: nil)
        }
    }

    @objc private func doneButtonTapped() {
        guard let color = selectedColor, let iconName = selectedIconName else {
            dismiss()
            return
        }
        delegate?.habitIconPickerController(self, color: color, iconName: iconName)

        dismiss()
    }

    @objc private func cancelButtonTapped() {
        dismiss()
    }

    private func iconName(at indexPath: IndexPath) -> String? {
        if (0 ..< iconNames.count).contains(indexPath.row) {
            return iconNames[indexPath.row]
        } else {
            return nil
        }
    }

    private func selectIcon(_ iconName: String?) {
        selectedIconName = iconName
    }

    private func color(at indexPath: IndexPath) -> UIColor? {
        if (0 ..< colors.count).contains(indexPath.row) {
            return colors[indexPath.row]
        } else {
            return nil
        }
    }

    private func selectColor(_ color: UIColor?) {
        selectedColor = color
    }
}

// MARK: - ColorPickerDelegate

extension HabitIconPickerController: UIColorPickerViewControllerDelegate {
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        selectColor(viewController.selectedColor)
    }
}

// MARK: - CollectionViewDelegate

extension HabitIconPickerController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case is ColorSelectorCollectionView:
            selectColor(color(at: indexPath))
        case is HabitIconCollectionView:
            selectIcon(iconName(at: indexPath))
        default:
            break
        }
    }
}

// MARK: - CollectionViewDataSource

extension HabitIconPickerController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if collectionView is ColorSelectorCollectionView {
            return colors.count
        } else {
            return iconNames.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = UICollectionViewCell()
        switch collectionView {
        case is ColorSelectorCollectionView:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "color-cell", for: indexPath) as? ColorSelectorCollectionView.Cell,
                (0 ..< colors.count).contains(indexPath.row)
            else {
                return defaultCell
            }
            let color = colors[indexPath.row]
            cell.color = color
            if color == selectedColor {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
                cell.isSelected = true
            }
            return cell
        case is HabitIconCollectionView:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "icon-cell", for: indexPath) as? HabitIconCollectionView.Cell,
                (0 ..< iconNames.count).contains(indexPath.row)
            else {
                return defaultCell
            }
            let iconName = iconNames[indexPath.row]
            cell.accentColor = selectedColor ?? .white
            cell.imageName = iconName
            if iconName == selectedIconName {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
                cell.isSelected = true
            }
            return cell
        default:
            return defaultCell
        }
    }
}

private extension HabitIconPickerController {
    static let cyan = UIColor(hexRGB: "#2AA8D0")!
    static let green = UIColor(hexRGB: "#119F39")!
    static let red = UIColor(hexRGB: "#D71A1A")!
    static let black = UIColor(hexRGB: "#3F3636")!
    static let blue = UIColor(hexRGB: "#1D59F3")!
    static let orange = UIColor(hexRGB: "#ED8627")!
}
