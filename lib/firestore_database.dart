import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfit/meal.dart';

Future<void> addUser(String userID, String email, bool onBoardStatus) {
  DocumentReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users').doc(userID);
  return users
      .set({
        'email': email,
        'isOnboarded': onBoardStatus,
        'status': 'free',
        'viewCredit': 10,
        'searchCredit': 5
      })
      .then((value) => print("User added successfully!"))
      .catchError((error) => print("Failed to add user: $error"));
}

Future<bool> getUserOnboardStatus(String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  try {
    QuerySnapshot querySnapshot =
        await users.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs.first.data();
      if (userData != null &&
          userData is Map<String, dynamic> &&
          userData.containsKey('isOnboarded')) {
        return userData['isOnboarded'] ?? false;
      } else {
        print('isOnboarded field not found or null.');
        return false;
      }
    } else {
      print('User not found!');
      return false;
    }
  } catch (e) {
    print('Error getting user onboard status: $e');
    return false;
  }
}

Future<void> updateUserOnboardStatus(String userId, bool onBoardStatus) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  print(users);
  print(users.doc(userId));
  try {
    // Get the document reference for the user
    DocumentReference userRef = users.doc(userId);

    await userRef.update({'isOnboarded': onBoardStatus});

    print("User onboard status updated successfully!");
  } catch (error) {
    print("Failed to update user onboard status: $error");
  }
}

// Update by Paywall
Future<void> updateUserAccountStatus(
    String userId, String accountStatus) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  int viewCredit = 0;
  int searchCredit = 0;

  if (accountStatus == 'Basic') {
    viewCredit = 20;
    searchCredit = 10;
  } else if (accountStatus == 'Premium') {
    viewCredit = 50;
    searchCredit = 20;
  }

  try {
    // Get the document reference for the user
    DocumentReference userRef = users.doc(userId);

    await userRef.update({
      'status': accountStatus,
      'viewCredit': viewCredit,
      'searchCredit': searchCredit,
    }).then((value) => print('status update'));

    print("User Account status updated successfully!");
  } catch (error) {
    print("Failed to update user Account status: $error");
  }
}

// Update by Paywall According to daily addtition
Future<void> getAndAddUserCredits(String userId, String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentReference userRef = users.doc(userId);

  try {
    QuerySnapshot querySnapshot =
        await users.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs.first.data();
      if (userData != null && userData is Map<String, dynamic>) {
        await userRef.update({
          'viewCredit': userData['viewCredit'] + 10,
          'searchCredit': userData['searchCredit'] + 5,
        }).then((value) => print('Fields updated'));
      } else {
        print('Credit field not found or null.');
      }
    } else {
      print('User not found!');
    }
  } catch (e) {
    print('Error getting user onboard status: $e');
  }
}

Future<bool> getAndUpdateUserViewCredit(String userId, String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentReference userRef = users.doc(userId);

  try {
    QuerySnapshot querySnapshot =
        await users.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs.first.data();
      if (userData != null && userData is Map<String, dynamic>) {
        if (userData['viewCredit'] == 0) {
          print('no Credit');
          return false;
        } else {
          await userRef.update({
            'viewCredit': userData['viewCredit'] - 1,
          }).then((value) {
            print('Fields updated');
          });
          return true;
        }
      } else {
        print('Credit field not found or null.');
        return false;
      }
    } else {
      print('User not found!');
      return false;
    }
  } catch (e) {
    print('Error getting user onboard status: $e');
    return false;
  }
}

Future<bool> getAndUpdateSearchCredit(String userId, String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentReference userRef = users.doc(userId);

  try {
    QuerySnapshot querySnapshot =
        await users.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs.first.data();
      if (userData != null && userData is Map<String, dynamic>) {
        if (userData['searchCredit'] == 0) {
          print('no Credit');
          return false;
        } else {
          await userRef.update({
            'searchCredit': userData['searchCredit'] - 1,
          }).then((value) {
            print('Fields updated');
          });
          return true;
        }
      } else {
        print('Credit field not found or null.');
        return false;
      }
    } else {
      print('User not found!');
      return false;
    }
  } catch (e) {
    print('Error getting user onboard status: $e');
    return false;
  }
}

Future<void> addBookmark(String userId, String mealId, Meal meal) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentReference userRef = users.doc(userId);
    // Convert Meal object to Map
    Map<String, dynamic> mealData = meal.toJson();

    // Store the meal data under the mealId in the user's document
    await userRef.collection('bookmarkedMeals').doc(mealId).set(mealData);

    print("Meal added to bookmarks successfully!");
  } catch (error) {
    print("Failed to add meal to bookmarks: $error");
  }
}

Future<String> checkUserStatus(String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  try {
    QuerySnapshot querySnapshot =
        await users.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs.first.data();
      if (userData != null &&
          userData is Map<String, dynamic> &&
          userData.containsKey('status')) {
        return userData['status'];
      } else {
        return 'status field not found or null.';
      }
    } else {
      return 'User not found!';
    }
  } catch (e) {
    print('Error getting user onboard status: $e');
    return 'error occured';
  }
}

// Function to delete a bookmark for a specific user
Future<void> deleteBookmark(String userId, int mealId) async {
  try {
    // Get reference to the user's bookmarkedMeals collection
    CollectionReference bookmarksRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookmarkedMeals');

    // Delete the document corresponding to the mealId
    await bookmarksRef.doc(mealId.toString()).delete();

    print('Meal with ID $mealId removed from bookmarks successfully.');
  } catch (error) {
    print('Error deleting bookmark: $error');
  }
}

Future<List<dynamic>> getUserBookmarkedMeals(String userId) async {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  try {
    // Get the document reference for the user
    DocumentReference userRef = userCollection.doc(userId);

    // Get the bookmarkedMeals collection reference
    CollectionReference bookmarkedMealsRef =
        userRef.collection('bookmarkedMeals');

    // Get the documents (bookmarked meals) from the collection
    QuerySnapshot querySnapshot = await bookmarkedMealsRef.get();

    // Extract the data from the documents
    List<dynamic> bookmarkedMeals = querySnapshot.docs
        .map((DocumentSnapshot document) => document.data())
        .toList();
    return bookmarkedMeals;
  } catch (error) {
    print("Error fetching bookmarked meals: $error");
    return [];
  }
}
