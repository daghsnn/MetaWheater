//
//  ViewController.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import UIKit

class ViewController: UIViewController {
    let array = ["1231","asdasd","asdasdasdda","dadadada"]
    private lazy var cv : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .yellow
        cv.isScrollEnabled = true
        return cv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cv)
        view.backgroundColor = .orange
        cv.frame = view.bounds
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
    }


}
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.label.text = array[indexPath.row]
        return cell
    }
    
    
}
