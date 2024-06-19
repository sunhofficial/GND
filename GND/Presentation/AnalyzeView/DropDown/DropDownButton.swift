//
//  DropDownButton.swift
//  GND
//
//  Created by 235 on 6/19/24.
//

import UIKit
protocol DropDownButtonDelegate: AnyObject {
    func didSelect(_ index: Int)
}
class DropDownButton: UIView {
    var dataSource: [DropRange] = [] {
        didSet {
            updateTableDataSource()
        }
    }
    var tableViewHeight: NSLayoutConstraint?
    var delegate: DropDownButtonDelegate?
    let button: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black
        config.title = DropRange.day.rawValue
        config.image = UIImage(systemName: "chevron.down")
        config.imagePadding = 40
        config.imagePlacement = .trailing
        config.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 8, bottom: 24, trailing: 8)
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1.2
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.gray.cgColor
        return button
    }()

    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 4
        stack.axis = .vertical
        return stack
    }()

    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isHidden = true
        table.layer.borderWidth = 1.2
        table.layer.borderColor = UIColor.gray.cgColor
        table.register(DropDownTabelCell.self, forCellReuseIdentifier: DropDownTabelCell.reuseIdentifier)
        return table
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setup() {
        addSubview(stackView)
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(tableView)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeight?.isActive = true
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo:topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    @objc private func buttonTapped() {
        tableView.isHidden.toggle()
    }
    func updateTableDataSource() {

        tableViewHeight?.constant = CGFloat(dataSource.count * 40)

        tableView.reloadData()
    }
}
extension DropDownButton: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTabelCell.reuseIdentifier, for: indexPath) as? DropDownTabelCell else { return UITableViewCell() }
        cell.set(dataSource[indexPath.row].rawValue)
        return cell
    }

}

extension DropDownButton: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        button.setTitle(dataSource[indexPath.row].rawValue, for: .normal)
        delegate?.didSelect(indexPath.row)
        tableView.isHidden = true
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
