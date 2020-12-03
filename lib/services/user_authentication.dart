import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reminder_note_app/models/firestore_database_wrapper.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<FirebaseUser> get authStateChanges => _firebaseAuth.onAuthStateChanged;

  Future<String> signIn({String email, String password}) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      FirestoreDatabaseWrapper.db.setUID(result.user);
      return "Signed In";
    } catch (error) {
      return error.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      String collection_name = 'notes_' + user.uid.toString();
      await Firestore.instance.collection(collection_name).document("0").setData({'firstName': 'a'});
      return "Signed Up";
    } catch (error) {
      return error.message;
    }
  }

  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return "Signed Out";
    } catch (e) {
      return e.message; // TODO: show dialog with error
    }
  }

  Future<void> register({String email, String password}) async {
    try {
      _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)
      .then((user) {
        // get user data from the auth trigger
      //   const userUid = user.uid; // The UID of the user.
      //   const email = user.email; // The email of the user.
      //   const displayName = user.displayName; // The display name of the user.

      //   // set account  doc  
      //   const account = {
      //     useruid: userUid,
      //     calendarEvents: []
      //   }
      //   firebase.firestore().collection('accounts').doc(userUid).set(account); 
      // })
      // .catch(function(error) {
      //   // Handle Errors here.
      //   var errorCode = error.code;
      //   var errorMessage = error.message;
        // ...
      });
    } catch (error) {
      print(error);
    }
  }
}