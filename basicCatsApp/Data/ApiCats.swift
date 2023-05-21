//
//  ApiCats.swift
//  basicCatsApp
//
//  Created by Daniel Duran Schutz on 20/05/23.
//

import Foundation

class ApiCats {
    static let shared = ApiCats()
    
    private let api_key = "bda53789-d59e-46cd-9bc4-2936630fde39"
    
    private let breedsLimit = "10"
    
    private func get_api_key() -> String{
        return api_key
    }
    
    private func get_breeds_limit() -> String{
        return breedsLimit
    }
    
    struct Routes {
        static let breedsUrl:String = "https://api.thecatapi.com/v1/breeds"
        static let breedImageSearchUrl:String = "https://api.thecatapi.com/v1/images/search"
        //static let imageByIdUrl:String = "https://api.thecatapi.com/v1/images/"
    }
    
    
    func requestBreeds(completion: @escaping([Cat]?)->()) throws {
            let urlBreeds = "\(Routes.breedsUrl + "?api_key=" + get_api_key())"
            guard let url = URL(string:urlBreeds) else {print("url unwrapping failed"); return }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil || data == nil {
                    print("Client error!")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error!")
                    return
                }
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    return
                }
                do {
                    if let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: []){
                            do {
                                let breeds =  try JSONDecoder().decode([Cat].self, from: data)
                                completion(breeds)
                            } catch let error {
                                print("error converting json - \(error.localizedDescription)")
                                completion(nil)
                            }
                        }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                    completion(nil)
                }

            }.resume()
        }
        
        func getBreedsWithPageNum(pageNum: Int, completion: @escaping([Cat])->()) throws {
            var breedsUrlString = "\(Routes.breedsUrl + "?api_key=" + get_api_key())"
            guard let url = URL(string:breedsUrlString) else {print("url list unwrapping failed"); return }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { print("data nil"); return }
                    do {
                        let breeds = try JSONDecoder().decode([Cat].self, from: data)
                        completion(breeds)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                
            }.resume()
        }
        
        func getImageByBreedId(breed:Cat, completion:@escaping((CatImage) ->())) throws {
            let breedImageUrlString = "\(Routes.breedImageSearchUrl + "?breed_id=" + (breed.id ?? "0"))"
            guard let url = URL(string:breedImageUrlString) else {print("url image unwrapping failed"); return }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { print("data nil"); return }
                    do {
                        let breedImage = try JSONDecoder().decode([CatImage].self, from: data)
                        for item in breedImage {
                            completion(item)
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
            }.resume()
            
        }
    
    
    
}
