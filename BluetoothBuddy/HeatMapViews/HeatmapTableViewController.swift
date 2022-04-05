//
//  HeatmapTableViewController.swift
//  DiscoveryChallenge
//
//  Created by Khondwani Sikasote on 2022/04/04.
//

import UIKit
import Alamofire

class HeatmapTableViewController: UITableViewController {
    
    var arrayOfFileNames: [String] = []
    var arrayOfHmtlPages: [String] = []
    let alert = UIAlertController(title: nil, message: "Fetching Heatmaps...", preferredStyle: .alert)
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestForMaps()
        setupActivityIndicatorAndAlert()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.navigationBar.prefersLargeTitles = false
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if arrayOfFileNames.count == 0 {
               self.tableView.setEmptyMessage("You currently have no Heatmaps - Reason Server could be off... Contact Khondwani at 0743794740")
        } else {
            self.tableView.restore()
            return arrayOfFileNames.count
        }
        return arrayOfFileNames.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "htmlMaps", for: indexPath) as! HeatmapTableViewCell
        // Configure the cell...
        cell.htmlName.text = arrayOfFileNames[indexPath.row]
        return cell
    }

    func requestForMaps() {
      
        // REASON I USE ALAMFIRE HAHA :) THIS BELOW WAS A PAIN
        //        let url = URL(string: "http://ec2-54-213-182-11.us-west-2.compute.amazonaws.com:3000/htmlFiles")!
//
//        var request = URLRequest(url: url)
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.httpMethod = "POST"
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data, let stringResponse = String(data: data, encoding: .utf8) {
//                                print("Response \(stringResponse)")
//
//                print(data)
//                let decoder = JSONDecoder()
//                do {
//                    let map = try decoder.decode([Map].self, from: data)
//                    print(map)
//                } catch {
//                    print(error.localizedDescription)
//                }
//            } else if let error = error {
//                print("HTTP Request Failed \(error)")
//            }
//        }
//
//        // lets call for execution
//        task.resume()
        self.startLoading()
        AF.request("http://ec2-54-213-182-11.us-west-2.compute.amazonaws.com:3000/htmlFiles", method: .post).responseJSON { response in
//            debugPrint(response.result)
            switch response.result {
                case .success:
//                    debugPrint(response.value as! [String: [String]])
                    let dict = (response.value as! [String: [String]])
                    for filename in dict["files"]! {
                        debugPrint((filename as NSString).lastPathComponent)
                        self.arrayOfFileNames.append((filename as NSString).lastPathComponent)
                        self.tableView.reloadData()
                    }
                
                    for htmlMap in dict["results"]! {
                        self.arrayOfHmtlPages.append(htmlMap)
                    }
                    self.stopLoading()
                    break
                case .failure:
                    debugPrint(response.error!)
                    self.stopLoading()
                    break
        
            }
        }

        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    var selectedHtmlPage: String = ""
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < arrayOfFileNames.count && indexPath.row < arrayOfHmtlPages.count {
            selectedHtmlPage = arrayOfHmtlPages[indexPath.row]
            performSegue(withIdentifier: "toMapView", sender: nil)
        }
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? WebViewViewController {
                        vc.htmlMapPage = selectedHtmlPage
        }
    }
    

}
