//
//  ViewCats.swift
//  basicCatsApp
//
//  Created by Daniel Duran Schutz on 20/05/23.
//

import UIKit

class ViewCats: UIViewController, ViewModelCatDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var cats:[Cat]?
    var catsImageList:[CatImage]? = []
    lazy var viewModelCat:ViewModelCat = {
       return ViewModelCat()
    }()
    var estimateWidth = 110.0
    var cellMarginSize = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Breed list"
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(
            UINib(nibName: "CatsCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "CatsCollectionViewCell")
        setupGridView()
        viewModelCat.setDelegate(delegate: self)
        
        cats = []
        viewModelCat.getCats()
    }
    
    func setupGridView(){
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    func onItemsFilled(list: [Cat]) {
        cats = list
        viewModelCat.getCatsImages { catImages in
            self.catsImageList = catImages
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
}

extension ViewCats:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatsCollectionViewCell", for: indexPath) as? CatsCollectionViewCell else {
            fatalError("Wrong cell class dequeued")
        }
        
        if let dataItem = cats?[indexPath.item] {
            let image = "https://cdn2.thecatapi.com/images/\(dataItem.referenceImageID ?? "").jpg"
            
            
            itemCell.setData(
                title: dataItem.name,
                imageUrl: image ?? "",
                origin:"Origin: \(dataItem.origin)",
                intelligence:"Intelligence: \(dataItem.intelligence)"
            )
            itemCell.contentView.layer.cornerRadius = 5.0
            itemCell.contentView.layer.borderWidth = 1.0
            itemCell.layer.shadowRadius = 5.0
        }
        return itemCell
    }
}
extension ViewCats:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWidth()
        return CGSize(width: width, height: width)
    }
    
    func calculateWidth() -> CGFloat {
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize))
        return width
    }
}


