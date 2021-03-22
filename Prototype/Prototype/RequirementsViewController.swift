//
//  RequirementsViewController.swift
//  Prototype
//
//  Created by Romain Brunie on 19/03/2021.
//

import UIKit

struct RequirementViewModel {
    let title: String
    let totalItems: Int
    let completedItems: Int
}

class RequirementsViewController: UIViewController {
    
    @IBOutlet weak var requirementCollectionView: UICollectionView!
    
    private let requirements = RequirementViewModel.prototypeRequirements

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        requirementCollectionView.dataSource = self
        requirementCollectionView.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "iOS App Development"
    }

}

extension RequirementsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        requirements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequirementCell", for: indexPath) as! RequirementCell
        let model = requirements[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

extension RequirementsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = CGFloat(2)
        let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
        let availableWidth = collectionView.frame.width - spacing * (itemsPerRow - 1)
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

extension RequirementCell {
    func configure(with model: RequirementViewModel) {
        title.text = model.title
        completedItemsDescription.text = "\(model.completedItems) of \(model.totalItems) completed"
    }
}
