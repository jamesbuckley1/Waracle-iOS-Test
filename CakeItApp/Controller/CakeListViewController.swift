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
    
    func getCakeData() {
        
        let url = URL(string: "https://gist.githubusercontent.com/hart88/79a65d27f52cbb74db7df1d200c4212b/raw/ebf57198c7490e42581508f4f40da88b16d784ba/cakeList")!
        let request = URLRequest(url: url)
        
        
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let decodedResponse = try? JSONDecoder().decode([Cake].self, from: data!) {
                self.cakes = decodedResponse
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                }
                
                return
            }
        }.resume()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? CakeDetailViewController else { return }
        vc.cake = cakes[selectedRow]
    }
}



