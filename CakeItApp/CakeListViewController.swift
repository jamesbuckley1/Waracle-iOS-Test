//
//  CakeListViewController.swift
//  CakeItApp
//
//  Created by David McCallum on 20/01/2021.
//

import UIKit

class CakeListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var i = 0
    var cakes: [Cake] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = "🎂CakeItApp🍰"
        
        let url = URL(string: "https://gist.githubusercontent.com/hart88/79a65d27f52cbb74db7df1d200c4212b/raw/ebf57198c7490e42581508f4f40da88b16d784ba/cakeList")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let decodedResponse = try? JSONDecoder().decode([Cake].self, from: data!) {
                self.cakes = decodedResponse
                self.tableView.reloadData()
                return
            }
        }.resume()
    }
}

extension CakeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        i = indexPath.row
        performSegue(withIdentifier: "segue", sender: tableView)
    }
    
}

extension CakeListViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CakeTableViewCell
        let cake = cakes[indexPath.row]
        cell.titleLabel.text = cake.title
        cell.descLabel.text = cake.desc
        
        
        
        
        let imageURL = URL(string: cake.image)!
        
        guard let imageData = try? Data(contentsOf: imageURL) else { return cell }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
            cell.cakeImageView.image = image
            }
        return cell
    }
}

