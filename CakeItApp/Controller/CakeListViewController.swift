//
//  CakeListViewController.swift
//  CakeItApp
//
//  Created by David McCallum on 20/01/2021.
//

import UIKit

class CakeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var selectedRow = 0
    var cakes = [Cake]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        title = "🎂CakeItApp🍰"
        
        getCakeData()
    }

    func downloadCakeData(completion: @escaping (Bool) -> ()) {
        let url = URL(string: "https://gist.githubusercontent.com/hart88/79a65d27f52cbb74db7df1d200c4212b/raw/ebf57198c7490e42581508f4f40da88b16d784ba/cakeList")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data")
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode([WireCake].self, from: data) {
                
                let wireCakes = decodedResponse
                
                let dispatchGroup = DispatchGroup()

                for wireCake in wireCakes {
                    
                    dispatchGroup.enter()

                    var cake = Cake()
                    cake.title = wireCake.title
                    cake.desc = wireCake.desc
                    
                    if let imageURL = URL(string: wireCake.image) {
                        if let imageData = try? Data(contentsOf: imageURL) {
                            cake.image = UIImage(data: imageData)
                        }
                        else {
                            cake.image = UIImage(named: "NoImage")
                        }

                        dispatchGroup.leave()
                    }
                    
                    self.cakes.append(cake)
               
                }
                
                dispatchGroup.notify(queue: .main, execute: {
                    completion(true)
                })

                
            }
        }.resume()
    }
    
    func getCakeData() {
        cakes = [Cake]()
        
        let spinner = SpinnerViewController()

        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        
        downloadCakeData { success in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    spinner.willMove(toParent: nil)
                    spinner.view.removeFromSuperview()
                    spinner.removeFromParent()
 
                }
            }
        }
        
    }
    
    // MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "showCake", sender: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CakeCell") as! CakeTableViewCell
        
        if cakes.count > 0 {
            let cake = cakes[indexPath.row]
            
            cell.titleLabel.text = cake.title
            cell.descLabel.text = cake.desc
            
            DispatchQueue.main.async {
                cell.cakeImageView.image = cake.image
            }
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? CakeDetailViewController else { return }
        vc.cake = cakes[selectedRow]
    }
}



