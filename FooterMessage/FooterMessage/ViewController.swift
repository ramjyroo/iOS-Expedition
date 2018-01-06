//
//  ViewController.swift
//  FooterMessage
//
//  Created by Ram on 06/01/18.
//  Copyright © 2018 Ram. All rights reserved.
//

import UIKit

class FloatUpFooter: UIView {
    let container: UIView
    let messageLabel: UILabel
    let messageImage: UIImageView
    
    override init(frame: CGRect) {
        container = UIView(frame: .zero)
        messageLabel = UILabel(frame: .zero)
        messageImage = UIImageView(frame: CGRect.zero)
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.backgroundColor = .clear
        container.backgroundColor = .clear
        self.addSubview(container)
        self.container.addSubview(messageImage)
        self.container.addSubview(messageLabel)
        
        let image: UIImage? = UIImage(named: "confetti")
        messageImage.image = image
        messageImage.contentMode = .scaleAspectFit
        messageImage.translatesAutoresizingMaskIntoConstraints = false
        messageImage.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        messageImage.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        messageImage.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        messageImage.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        messageLabel.text = "All caught up!!"
        messageLabel.sizeToFit()
        messageLabel.backgroundColor = .clear
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leadingAnchor.constraint(equalTo: self.messageImage.trailingAnchor, constant: 5.0).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5.0).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: self.messageImage.centerYAnchor, constant: 0.0).isActive = true
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
    }
}

class ViewController: UIViewController {
    
    let numberCellIdentifier = "NumberCell"
    
    let tableView: UITableView
    let floatUpFooter: FloatUpFooter
    var bottomAnchor: NSLayoutConstraint? = nil
    
    let moveDownConstant:CGFloat = 150
    let moveUpConstant:CGFloat = -50
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: CGRect.zero)
        floatUpFooter = FloatUpFooter(frame: .zero)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(floatUpFooter)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: numberCellIdentifier)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.getTopAnchor()).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.getBottomAnchor()).isActive = true
        
        self.floatUpFooter.configure()
        self.floatUpFooter.translatesAutoresizingMaskIntoConstraints = false
        self.floatUpFooter.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.floatUpFooter.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.floatUpFooter.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        let bottomAnchor = self.floatUpFooter.bottomAnchor.constraint(equalTo: getBottomAnchor(), constant: moveDownConstant)
        bottomAnchor.isActive = true
        self.bottomAnchor = bottomAnchor
        
    }
    
    func getTopAnchor() -> NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.topAnchor
        } else {
            // Fallback on earlier versions
            return self.topLayoutGuide.bottomAnchor
        }
    }
    
    func getBottomAnchor() -> NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            // Fallback on earlier versions
            return self.bottomLayoutGuide.topAnchor
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.numberCellIdentifier, for: indexPath)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        let number = indexPath.row as NSNumber
        cell.textLabel?.text = numberFormatter.string(from: number)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let bottomAnchor = self.bottomAnchor else { return }
        guard scrollView.contentSize.height > scrollView.frame.size.height else { return }
        let heightOfInvisibleContent = (scrollView.contentSize.height - scrollView.frame.size.height)
        print("height of invisible content: \(heightOfInvisibleContent), offset: \(scrollView.contentOffset.y)")
        guard scrollView.contentOffset.y >= heightOfInvisibleContent else { return }
        bottomAnchor.constant = moveUpConstant
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let bottomAnchor = self.bottomAnchor else { return }
        bottomAnchor.constant = moveDownConstant
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}






