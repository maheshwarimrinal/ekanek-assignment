//
//  AppSettingsViewController.swift
//  ekanek-assignment
//
//  Created by Mrinal Maheshwari on 24/05/20.
//  Copyright © 2020 Mrinal Maheshwari. All rights reserved.
//

import UIKit

class AppSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var values = [2,3,4]
    
    let settingsTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var optionPicker = UIPickerView()

    var toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "Settings"
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
        navigationItem.rightBarButtonItem = cancelBarButton
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsTable")
        
        optionPicker.delegate = self
        optionPicker.dataSource = self
        
        self.view.addSubview(settingsTableView)
        setLayout()
    }
    
    @objc func dismissSelf(){
        navigationController?.popViewController(animated: true)
    }
    
    func setLayout(){
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "settingsTable")
        if indexPath.row == 0 {
            cell.textLabel?.text = "Display Size"
            cell.detailTextLabel?.text = "\(defaultDisplayCells)"
        }
        if indexPath.row == 1{
            cell.textLabel?.text = "Clear all saved data"
            cell.detailTextLabel?.text = "Removes all your searched data"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            showPicker()
        }
        if indexPath.row == 1{
            SaveImageLocally().clearAllFilesFromTempDirectory()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(values[row])"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    func showPicker() {
        optionPicker = UIPickerView.init()
        optionPicker.delegate = self
        optionPicker.backgroundColor = UIColor.white
        optionPicker.setValue(UIColor.black, forKey: "textColor")
        optionPicker.autoresizingMask = .flexibleWidth
        optionPicker.contentMode = .center
        optionPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(optionPicker)

        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(doneButton))]
        self.view.addSubview(toolBar)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaultDisplayCells = values[row]
    }
    
    @objc func doneButton(){
        toolBar.removeFromSuperview()
        optionPicker.removeFromSuperview()
    }
}
