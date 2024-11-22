import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'wrestler_states.dart';

class WrestlerCubit extends Cubit<WrestlerStates> {
  WrestlerCubit() : super(WrestlerInitial());

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  List noteList = [];

  void addWrestler(
      {required String wrestlerName,
      required String catId,
      required String followers,
      required bool isFollowedByMe}) {
    if (wrestlerName.isEmpty || followers.isEmpty) {
      emit(AddWrestlerFailure());
    } else {
      emit(AddWrestlerLoading());
      try {
        categories.doc(catId).collection('wrestlers').add({
          'name': wrestlerName,
          'followers': followers,
          'isFollowedByMe': isFollowedByMe,
          'time': DateTime.now(),
        }).then((value) => log("note Added"));
        emit(AddWrestlerSuccess());
      } catch (e) {
        log("Failed to add note: ${e.toString()}");
        emit(AddWrestlerFailure());
      }
    }
  }

  void getCollection({required String catId}) {
    if (noteList.isEmpty) {
      emit(WrestlerLoading());
    }
    List test = [];

    categories
        .doc(catId)
        .collection('wrestlers')
        .orderBy('time')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        test.add(doc);
      }
      noteList = test;
      emit(WrestlerSuccess(wrestlerList: noteList));
    }).catchError((error) {
      log("Failed to get notes: $error");
      emit(WrestlerFailure());
    });
  }

  void deleteWrestler({required String id, required String noteId}) async {
    try {
      categories.doc(id).collection('wrestlers').doc(noteId).delete();
    } catch (e) {
      log(e.toString());
    }
  }

  void deleteAllWrestlers({required String id}) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    try {
      categories.doc(id).collection('wrestlers').get().then((querySnapshot) async {
        querySnapshot.docs.forEach((document) {
          batch.delete(document.reference);
        });
        await batch.commit();

        getCollection(catId: id);

        emit(DeleteAllWrestlersSuccess());
      });
      emit(DeleteAllWrestlersSuccess());
    } catch (e) {
      log(e.toString());
      emit(DeleteAllWrestlersFailure());
    }
  }

  void updateWrestler(
      {required String id,
      required String name,
      required String noteId,
      required String followersCount}) {
    if (name.isEmpty) {
      emit(UpdateWrestlerFailure());
    } else {
      emit(UpdateWrestlerLoading());
      categories.doc(id).collection('wrestlers').doc(noteId).set(
          {'name': name, 'followers': followersCount},
          SetOptions(merge: true)).then((value) {
        emit(UpdateWrestlerSuccess());
      }).catchError((error) {
        emit(UpdateWrestlerFailure());
      });
      /*
      categories.doc(id).update({'name': name}).then((value) {
        emit(UpdateCategorySuccess());
      }).catchError((error) {
        emit(UpdateCategoryFailure());
      });
      */
    }
  }

  void updateFollowers(
      {required String id,
      required String noteId,
      String? followers,
      required bool isFollowedByMe}) {
    DocumentReference note = FirebaseFirestore.instance
        .collection('categories')
        .doc(id)
        .collection('wrestlers')
        .doc(noteId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(note);

      if (!snapshot.exists) {
        emit(UpdateFollowersFailure());
      }

      // Update the follower count based on the current count
      // Note: this could be done without a transaction
      // by updating the population using FieldValue.increment()

      final data = snapshot.data() as Map<String, dynamic>;

      int newFollowerCount = 0;
      int currentFollowers = int.parse(data['followers']) ?? 0;
      newFollowerCount =
          isFollowedByMe ? currentFollowers - 1 : currentFollowers + 1;

      // Perform an update on the document
      transaction.update(note, {'followers': newFollowerCount.toString()});
      transaction.update(note, {'isFollowedByMe': !isFollowedByMe});

      // Return the new count
      //return newFollowerCount;
    }).then((value) {
      emit(UpdateFollowersSuccess());
    }).catchError((error) {
      log(error.toString());
      emit(UpdateFollowersFailure());
    });
  }
}
