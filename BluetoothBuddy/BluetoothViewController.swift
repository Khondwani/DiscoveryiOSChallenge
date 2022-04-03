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
    
    var arrayOfBluetoothDevices: [[String:Any]] = [[:]]
    var centralManager: CBCentralManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting up the CBCentralManager
        centralManager = CBCentralManager(delegate: self, queue: .main)
        setupTable()
        
    }

    // setup table
    func setupTable() {
        self.bluetoothTable.dataSource = self
        self.bluetoothTable.delegate = self
//        self.bluetoothTable.tableFooterView = UIView()
    }
    
    //MARK: TABLE DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return arrayOfBluetoothDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.bluetoothTable.dequeueReusableCell(withIdentifier: "bluetoothCell") as! BluetoothTableViewCell
        if arrayOfBluetoothDevices.count != 0 {
            cell.name.text = (arrayOfBluetoothDevices[indexPath.row]["peripheral"] as? CBPeripheral)?.name
            cell.distanceAway.text = "\(self.calculateDistanceOfPeripheral(rssiValue: (arrayOfBluetoothDevices[indexPath.row]["rssi"] as? NSNumber) ?? 0)) meters"
        }
        return cell
    }
    
    //mark: CBCENTRALMANAGER DELEGATE
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // let us check if bluetooth is on
        self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name != nil {
            print("Distance: ",calculateDistanceOfPeripheral(rssiValue: RSSI)," meters")
            let newPeripheral = [
                "peripheral": peripheral,
                "rssi": RSSI
            ] as [String: Any]
            self.arrayOfBluetoothDevices.append(newPeripheral)
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
        let N = 2
        
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
    

}

