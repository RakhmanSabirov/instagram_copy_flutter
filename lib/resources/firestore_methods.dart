import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
      String description,
      Uint8List file,
      String uid,
      String username,
      String profImage,
      ) async{
    String res = "Ощибка";
    try{
      String photoUrl = await StorageMethods().uploadImageToStorage("posts", file, true);

      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage);
      
      _firestore.collection("posts").doc(postId).set(post.toJson());
      res = "Удачно";
    } catch(err){
      res = err.toString();
    }
    return res;
  }
  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> postComment(String postId,String text, String uid,String name,String profilePic,List commentLikes) async{

    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name' : name,
          'uid' : uid,
          'text' : text,
          'commentId': commentId,
          'datePublished' : DateTime.now(),
          'commentLikes' : [],
        });
      } else{
        print("Text is empty");
      }
    }catch(e){
      print(e.toString());
    }
  }
  Future<String> likeComments(String postId,String commentId, String uid, List commentLikes) async {
    String res = "Some error occurred";
    try {
      if (commentLikes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({
          'commentLikes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({
          'commentLikes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> deletePost(String postId) async{
    try{
      await _firestore.collection('posts').doc(postId).delete();
    }
    catch(err){
      print(err.toString());
    }
  }
  Future<void> followUser(String uid,String followId) async{
    try{
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)){
        await _firestore.collection('users').doc(followId).update({
          'followers' : FieldValue.arrayRemove([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayRemove([followId]),
        });
      }else{
        await _firestore.collection('users').doc(followId).update({
          'followers' : FieldValue.arrayUnion([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayUnion([followId]),
        });
      }
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
  }
}