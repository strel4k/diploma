//
//  ProfileDataHandler.swift
//  Diplom
//
//  Created by Mac on 07.01.2023.
//

import UIKit
import CoreData

class ProfileDataHandler {
    
    var managedContext: NSManagedObjectContext!
    
    func setManagedContext(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func addProfile(login: String, password: String, name: String, status: String, image: UIImage) {
        
        guard let profileEntity = NSEntityDescription.entity(forEntityName: "Profile", in: self.managedContext)
        else { return }
        
        let profile = Profile(entity: profileEntity, insertInto: self.managedContext)
        profile.login = login
        profile.password = password
        profile.name = name
        profile.status = status
        
        guard let photoEntity = NSEntityDescription.entity(forEntityName: "Photo", in: self.managedContext)
        else {
            print("Error - cannot load photo entity")
            saveManagedContext()
            return
        }
        
        let photo = Photo(entity: photoEntity, insertInto: self.managedContext)
        photo.name = name
        photo.imageData = image.pngData()
        photo.profile = profile
        profile.avatar = photo
        profile.addToPhotos(photo)
        
        guard let postEntity = NSEntityDescription.entity(forEntityName: "Post", in: self.managedContext)
        else {
            print("Error - cannot load post entity")
            saveManagedContext()
            return
        }
        
        let post = Post(entity: postEntity, insertInto: self.managedContext)
        post.profile = profile
        post.photo = photo
        post.title = name
        post.postText = status
        post.likes = 0
        post.views = 0
        
        profile.addToPosts(post)
        
        saveManagedContext()

    }
    
    func saveManagedContext() {
        
        do {
            try managedContext.save()
        } catch {
            print("Save profile error.")
        }
        
    }
     
    func loadProfile(by login: String) -> Profile? {
        
        let profileRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        profileRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Profile.login), login)
        
        do{
            let profiles = try managedContext.fetch(profileRequest)
            return profiles.first
        } catch {
            print("No results for \(login)")
        }
        
        return nil
    }
    
//    func deleteProfile(by login: String) {
//
//        let profileRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
//        profileRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Profile.login), login)
//
//
//
//        do{
//            let profiles = try managedContext.fetch(profileRequest)
//                managedContext.delete(profiles.first!)
//
//        } catch {
//            print("No results for \(login)")
//        }
//
//
//    }
//
    func addPhotoToProfile(photoImage: UIImage, photoName: String, profile: Profile) {
        
        guard let photoEntity = NSEntityDescription.entity(forEntityName: "Photo", in: self.managedContext)
        else {
            print("Error - cannot load photo entity")
            saveManagedContext()
            return
        }
        
        let photo = Photo(entity: photoEntity, insertInto: self.managedContext)
        photo.name = photoName
        photo.imageData = photoImage.pngData()
        photo.profile = profile
        profile.addToPhotos(photo)
        
        saveManagedContext()
    }
    
    func addPostToProfile(postTitle: String, postText: String, postPhoto: UIImage, profile: Profile) {
        
        guard let photoEntity = NSEntityDescription.entity(forEntityName: "Photo", in: self.managedContext)
        else {
            print("Error - cannot load photo entity")
            saveManagedContext()
            return
        }
        
        let photo = Photo(entity: photoEntity, insertInto: self.managedContext)
        photo.name = postTitle
        photo.imageData = postPhoto.pngData()
        photo.profile = profile
        profile.addToPhotos(photo)
        
        guard let postEntity = NSEntityDescription.entity(forEntityName: "Post", in: self.managedContext)
        else {
            print("Error - cannot load post entity")
            saveManagedContext()
            return
        }
        
        let post = Post(entity: postEntity, insertInto: self.managedContext)
        
        post.title = postTitle
        post.photo = photo
        post.postText = postText
        post.likes = 0
        post.views = 0
        post.profile = profile
        
        profile.addToPosts(post)
        
        saveManagedContext()
    }
    
    func loadPosts() -> [Post] {
        
        var posts = [Post]()
        
        let postRequest: NSFetchRequest<Post> = Post.fetchRequest()
        
        do{
            let fetchPosts = try managedContext.fetch(postRequest)
            posts = fetchPosts
        } catch {
            print("No results")
        }
        return posts
    }
    
    func deletePost(post: Post, profile: Profile) {
        
        guard let index = profile.posts?.firstIndex(of: post)
        else { return }
        
        profile.replacePosts(at: index, with: post)
        
        self.saveManagedContext()
        
        managedContext.delete(post)
        self.saveManagedContext()
    }
    
//    func printPosts() {
//
//        let postRequest: NSFetchRequest<Post> = Post.fetchRequest()
//
//        do{
//            let posts = try managedContext.fetch(postRequest)
//            for post in posts {
//                print(post.title, post.postText)
//            }
//        } catch {
//            print("No results")
//        }
//    }
}

var profileDataHandler = ProfileDataHandler()

extension ProfileDataHandler {
    
    func fillData() {
        
        let email0 = "d@m.r"
        let email1 = "2d@g.com"
        let email2 = "noodle@gm.ru"
        let email3 = "murdoc@ya.ru"
        let email4 = "rus@ml.co.uk"
        
        let profileRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
 
        do{
            let profiles = try managedContext.fetch(profileRequest)
            if profiles.count != 0 { return }
        } catch {
            print("Can not fetch profiles. Line 215")
        }
        
        self.addProfile(login: email0, password: "12345678", name: "Bruce Wayne", status: "I'm a vengance", image: UIImage(named: "d - a") ?? UIImage())
        guard let profile0 = self.loadProfile(by: email0) else { return }
        
        self.addPostToProfile(
            postTitle: "1st fact",
            postText: "Bruce Wayne, also known by his superhero vigilante alias Batman, is a fictional character in the DC Extended Universe (DCEU), based on the DC Comics character of the same name.",
            postPhoto: UIImage(named: "d - p1") ?? UIImage(),
            profile: profile0)
        
        self.addPostToProfile(
            postTitle: "2nd fact",
            postText: "Batman’s fame came from his comic Batman released in 1940, but he first appeared in Detective Comics #27 in 1939.",
            postPhoto: UIImage(named: "d - p2") ?? UIImage(),
            profile: profile0)
        
        self.addPostToProfile(
            postTitle: "3rd fact",
            postText: "In order of appearance, the actors who have played our beloved Batman are Lewis G Wilson, Robert Lowrey Adam West, Michael Keaton, Val Kilmer, George Clooney, Christian Bale, Will Arnett, and the last, and in some people’s opinions worst, batman is Ben Affleck.",
            postPhoto: UIImage(named: "d - p3") ?? UIImage(),
            profile: profile0)
        
        self.addPostToProfile(
            postTitle: "4th fact",
            postText: "Frank Miller is generally credited with restoring Batman to his old gritty self with “The Dark Knight Returns.” This was a four-issue series published in 1986, where an aged Batman comes out of retirement, joined by a new Robin, to clean up the streets of a Gotham run amok.",
            postPhoto: UIImage(named: "d - p4") ?? UIImage(),
            profile: profile0)
        
        for i in 1...15 {
            
            let photoName = "d - \(i)"
            
            self.addPhotoToProfile(
                photoImage: UIImage(named: photoName)!,
                photoName: "Bruce Wayne - \(photoName)",
                profile: profile0)
        }
        
        
        self.addProfile(login: email1, password: "12345678", name: "Clark Kent", status: "Hello there!", image: UIImage(named: "2d - a")!)
        
        guard let profile1 = self.loadProfile(by: email1) else { return }
        
        self.addPostToProfile(
            postTitle: "1st fact",
            postText: "Superman made his debut in 1938, and the Superman logo was trademarked for this release. Superman was designed and written by Jerry Siegel and Joe Shuster, who came up with the famous logo.",
            postPhoto: UIImage(named: "2d - p1") ?? UIImage(),
            profile: profile1)
        
        self.addPostToProfile(
            postTitle: "2nd fact",
            postText: "It is quite common throughout DC Comics for superheroes to die, and most of the time, they find a way to come back. Superman has had his fair share of visiting the afterlife, but he has one death in particular which stood out.The most iconic death was in the 1993 comic titled “The Death of Superman.” In this story, Superman is beaten to death by Doomsday, and they both die fighting each other. Later on, Superman is brought back to life, which wasn’t the first time this happened.",
            postPhoto: UIImage(named: "2d - p2") ?? UIImage(),
            profile: profile1)
        
        self.addPostToProfile(
            postTitle: "3rd fact",
            postText: "The first television series about Superman was “Adventures of Superman,” which aired on September 19, 1952. Filming began in 1951, and American actor George Reeves played Superman. It was so popular that there ended up being six seasons with a total of 104 episodes. The final episode aired on April 28, 1958.",
            postPhoto: UIImage(named: "2d - p3") ?? UIImage(),
            profile: profile1)
        
        self.addPostToProfile(
            postTitle: "4th fact",
            postText: "Kryptonite is Superman’s biggest weakness; however, he has no protection against magic either. Superman is not a magical being, he is a human with enhanced features, and he can’t win against magic. This lack of protection means that he is vulnerable to magical objects such as Aquaman’s trident and Wonder Woman’s sword.",
            postPhoto: UIImage(named: "2d - p4") ?? UIImage(),
            profile: profile1)
        
        for i in 1...15 {
            
            let photoName = "2d - \(i)"
            
            self.addPhotoToProfile(
                photoImage: UIImage(named: photoName)!,
                photoName: "Clark Kent - \(photoName)",
                profile: profile1)
        }
        
        self.addProfile(login: email2, password: "12345678", name: "Diana Prince", status: "Go training!", image: UIImage(named: "n - a") ?? UIImage())
        
        guard let profile2 = self.loadProfile(by: email2) else { return }
        
        self.addPostToProfile(
            postTitle: "1st fact",
            postText: "She first appeared in the public eye at the World Fair in 1939, where she saved President Franklin Delano Roosevelt.",
            postPhoto: UIImage(named: "n - p1") ?? UIImage(),
            profile: profile2)
        
        self.addPostToProfile(
            postTitle: "2nd fact",
            postText: "Wonder Woman’s debut was in All-Star Comics #8, released in October 1941.",
            postPhoto: UIImage(named: "n - p2") ?? UIImage(),
            profile: profile2)
        
        self.addPostToProfile (
            postTitle: "3rd fact",
            postText: "Wonder Woman was one of the first superheroes to get her own book, after Superman and Batman.",
         postPhoto: UIImage(named: "n - p3") ?? UIImage(),
         profile: profile2)
        
        self.addPostToProfile(
            postTitle: "4th fact",
            postText: "Wonder Woman was the world’s first superheroine to appear in mainstream media.",
            postPhoto: UIImage(named: "n - p4") ?? UIImage(),
            profile: profile2)
        
        for i in 1...15 {
            
            let photoName = "n - \(i)"
            
            self.addPhotoToProfile(
                photoImage: UIImage(named: photoName)!,
                photoName: "Diana Prince - \(photoName)",
                profile: profile2)
        }
        
        self.addProfile(login: email3, password: "12345678", name: "Barry Allen", status: "Whose first!", image: UIImage(named: "m - a")!)
        
        guard let profile3 = self.loadProfile(by: email3) else { return }
    
        self.addPostToProfile(
            postTitle: "1st fact",
            postText: "The Flash can process information so fast that he can almost predict the future. He can quickly perceive nearly every possible outcome to determine the best choices to make.",
            postPhoto: UIImage(named: "m - p1") ?? UIImage(),
            profile: profile3)
        
        self.addPostToProfile(
            postTitle: "2nd fact",
            postText: "His speed force can even negate the anti-life equation. For example, one time when Barry Allen’s wife was under the control of the anti-life, he kissed her and then the speed force surrounded her and she regained her free will.",
            postPhoto: UIImage(named: "m - p2") ?? UIImage(),
            profile: profile3)
        
        self.addPostToProfile(
            postTitle: "3rd fact",
            postText: "Speedsters can rob objects of their kinetic energy, motion, or momentum, such as bullets in flight or turning a supervillain into a statue. They can also use their energy to accelerate themselves even faster.",
            postPhoto: UIImage(named: "m - p3") ?? UIImage(),
            profile: profile3)
        
        self.addPostToProfile(
            postTitle: "4th fact",
            postText: "Some speedsters, like Wally West, have an ability called “Energy Construct Creation.” This ability allows them to manipulate the speed force to create constructs similar to the way Green Lanterns do.",
            postPhoto: UIImage(named: "m - p4") ?? UIImage(),
            profile: profile3)

    
        
        for i in 1...15 {
            
            let photoName = "m - \(i)"
            
            self.addPhotoToProfile(
                photoImage: UIImage(named: photoName) ?? UIImage(),
                photoName: "Barry Allen - \(photoName)",
                profile: profile3)
        }
        
        self.addProfile(login: email4, password: "12345678", name: "Arthur Curry", status: "member of Gorillaz", image: UIImage(named: "r - a")!)
        
        guard let profile4 = self.loadProfile(by: email4) else { return }
        
        self.addPostToProfile(
            postTitle: "1st fact",
            postText: "It’s generally accepted that Aquaman can lift well over 100 tons and his feats of strength include: tossing a tank, pushing a tectonic plate downward onto a trench, lifting a cruise liner, and sucker punching Superman, amongst many others. It would take reinforced barriers to have a chance of slowing him down.",
            postPhoto: UIImage(named: "r - p1") ?? UIImage(),
            profile: profile4)
        self.addPostToProfile(
            postTitle: "2nd fact",
            postText: "He’s shown the strength to throw a submarine from the bottom of the ocean to the top of the ocean.",
            postPhoto: UIImage(named: "r - p2") ?? UIImage(),
            profile: profile4)
        
        self.addPostToProfile(
            postTitle: "3rd fact",
            postText: "Being the King of Atlantis and of the Seven Seas, Aquaman has full control of all the Earth’s oceans. He literally reigns over 70% of the planet.",
            postPhoto: UIImage(named: "r - p3") ?? UIImage(),
            profile: profile4)
        
        self.addPostToProfile(
            postTitle: "4th fact",
            postText: "To help him learn how to hone his gift of marine telepathy, Arthur’s father, Tom, would often place Arthur into a tank with some ill-tempered swordfish and have to convince them that he was not a threat before they started spearing his tiny body. Arthur grew up with electric eels and octopuses, and he became very used to the creatures and lost his fear of them, knowing that he could ask or convince them not to attack. He even became so comfortable with sharks that he’d ride them like horses as a kid.",
            postPhoto: UIImage(named: "r - p4") ?? UIImage(),
            profile: profile4)

        for i in 1...15 {
            
            let photoName = "r - \(i)"
            
            
            self.addPhotoToProfile(
                photoImage: UIImage(named: photoName)!,
                photoName: "Arthur Curry - \(photoName)",
                profile: profile4)
        }
    }
        
}
