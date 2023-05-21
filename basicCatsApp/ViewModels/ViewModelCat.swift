//
//  ViewModelCat.swift
//  basicCatsApp
//
//  Created by Daniel Duran Schutz on 20/05/23.
//


import Foundation

protocol ViewModelCatDelegate {
    func onItemsFilled(list:[Cat])
}

class ViewModelCat {
    let breedsService = ApiCats.shared
    
    var cats:[Cat]? = []
    var breedImageList:[CatImage]? = []
    var breedItems:[CatItem]? = []
    var listenerRequestBreedsByPage:(([Cat]) -> ())?
    private var delegate:ViewModelCatDelegate?
    
    func setDelegate(delegate:ViewModelCatDelegate){
        self.delegate = delegate
    }
    
    func getCats(){
        breedItems = []
        do{
            try breedsService.requestBreeds(completion: {(breeds) in
                guard let breeds = breeds, !breeds.isEmpty else {
                    //self.getCats()
                    return
                }
                self.cats = breeds
                self.delegate?.onItemsFilled(list: self.cats ?? [])
                
                
            })
        } catch let error {
            print("error in getData - \(error)")
        }
    }
    
    func getCatsImages(completion: @escaping([CatImage])->()){
        self.breedImageList = []
        for item in cats ?? [] {
            do{
                try breedsService.getImageByBreedId(breed: item, completion: { (breedImage) in
                        self.breedImageList?.append(
                            breedImage
                        )
                    if ((self.breedImageList?.count ?? 0) + 1) == self.cats?.count {
                        completion(self.breedImageList ?? [])
                    }
                })

            }catch let error{
                print("error in getData - \(error)")
            }
            
        }
        
    }
        
}
