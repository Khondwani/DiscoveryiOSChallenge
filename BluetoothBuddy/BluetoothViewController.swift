//
//  BluetoothViewController.swift
//  BluetoothBuddy
//
//  Created by Khondwani Sikasote on 2022/04/02.
//

import UIKit
import Foundation
import CoreBluetooth

class BluetoothViewController: UIViewController, UITableViewDataSource, CBCentralManagerDelegate, UITableViewDelegate {
    
    @IBOutlet weak var bluetoothTable: UITableView!
    
    var arrayOfBluetoothDevices: [[String:Any]] = []
    var centralManager: CBCentralManager? = nil
    let alert = UIAlertController(title: nil, message: "Searching...", preferredStyle: .alert)
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting up the CBCentralManager
        centralManager = CBCentralManager(delegate: self, queue: .main)
        setupTable()
        setupActivityIndicatorAndAlert()
        
    }
    
    func setupActivityIndicatorAndAlert() {
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.color = .blue
        alert.view.addSubview(loadingIndicator)
    }
    
    func startLoading() {
        loadingIndicator.startAnimating()
        present(alert, animated: true, completion: nil)
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
        dismiss(animated: false, completion: nil)
    }

    // setup table
    func setupTable() {
        self.bluetoothTable.dataSource = self
        self.bluetoothTable.delegate = self
//        self.bluetoothTable.tableFooterView = UIView()
    }
    
    //MARK: TABLE DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrayOfBluetoothDevices.count == 0 {
               self.bluetoothTable.setEmptyMessage("Scan for blueooth devices around you!")
        } else {
            self.bluetoothTable.restore()
            return arrayOfBluetoothDevices.count
        }
        return arrayOfBluetoothDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.bluetoothTable.dequeueReusableCell(withIdentifier: "bluetoothCell") as! BluetoothTableViewCell
   
          
        if (arrayOfBluetoothDevices[indexPath.row]["rssi"] as? NSNumber) != nil {
            cell.name.text = (arrayOfBluetoothDevices[indexPath.row]["peripheral"] as? CBPeripheral)?.name
            cell.distanceAway.text = String(format: "Distance away: %.2f meters", self.calculateDistanceOfPeripheral(rssiValue: ((arrayOfBluetoothDevices[indexPath.row]["rssi"] as? NSNumber)!))
            )
        }
        return cell
    }
    
    //mark: CBCENTRALMANAGER DELEGATE
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
       

        // let us check if bluetooth is on
        switch central.state {
            case .poweredOn:
                break
            case .poweredOff:
                let alert = UIAlertController(title: "Bluetooth Is Off", message: "It is required to find bluetooth buddies around you!", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true, completion: nil)
                break
            case .resetting:
                break
            case .unauthorized:
                break
            case .unsupported:
                break
            case .unknown:
                break
            default:
                break
            }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name != nil && RSSI != 0{
            print("Distance: ",calculateDistanceOfPeripheral(rssiValue: RSSI)," meters")
            let newPeripheral = [
                "peripheral": peripheral,
                "rssi": RSSI
            ] as [String: Any]
            
            let found = self.arrayOfBluetoothDevices.filter {
                ($0["peripheral"] as! CBPeripheral).name == peripheral.name
            }
            if found.count == 0 {
                self.arrayOfBluetoothDevices.append(newPeripheral)
            }
            self.stopLoading()
            
        }
        self.bluetoothTable.reloadData()
    }
    // Will use the RSSI (Received Signal Strength Indicator ) to approximate the distance between my phone and the peripheral device that is available
    func calculateDistanceOfPeripheral(rssiValue: NSNumber) -> Double {
        // Formula d = 10^((P−S)/10*N)
        /*
        d - estimated distance in meters

        P - beacon broadcast power in dBm at 1 m (Tx Power or Measured Power)

        S - measured signal value (RSSI) in dBm

        N - environmental factor (usually value between 2 (Low strength) and 4 (High strength))
        */
        let P = -61 //hard coded power value. Usually ranges between -59 to -65
        let N = 4
        
        let S = rssiValue
//
        if S == 0 {
            return -1.0
        }
        
        let part1 = Double(P - S.intValue)
        let part2 = Double(10*N)
        let part3 = part1 / part2
        
        let distance = pow(10.0, part3)
        return distance
    }
    
    @IBAction func scan(_ sender: Any) {
        self.startLoading()
        self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
}
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

