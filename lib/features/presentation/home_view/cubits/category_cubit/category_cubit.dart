import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'category_states.dart';

class CategoryCubit extends Cubit<CategoryStates> {
  CategoryCubit() : super(CategoryInitial()) {
    _init();
  }

  void _init() {
    getCategories(); // Optionally, load tasks right after the database is created
  }

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  List categoryList = [];

  void addCategory({required String categoryName}) {
    if (categoryName.isEmpty) {
      emit(AddCategoryFailure());
    } else {
      emit(AddCategoryLoading());
      try {
        categories.add({
          'name': categoryName,
          'id': FirebaseAuth.instance.currentUser!.uid
        }).then((value) => log("Category Added"));
        emit(AddCategorySuccess());
      } catch (e) {
        log("Failed to add category: ${e.toString()}");
        emit(AddCategoryFailure());
      }
    }
  }

  void getCategories() {
    if (categoryList.isEmpty) {
      emit(CategoryLoading());
    }
    List test = [];
    categories
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        test.add(doc);
      }
      categoryList = test;
      // Emit success state only after data is fetched
      emit(CategorySuccess(categoryList: categoryList));
    }).catchError((error) {
      log("Failed to get categories: $error");
      emit(CategoryFailure());
    });
  }

  void deleteCategory({required String id}) async {
    try {
      categories.doc(id).delete();
    } catch (e) {
      log(e.toString());
    }
  }

  void updateCategory({required String id, required String name}) {
    if (name.isEmpty) {
      emit(AddCategoryFailure());
    } else {
      emit(UpdateCategoryLoading());
      categories
          .doc(id)
          .set({'name': name}, SetOptions(merge: true)).then((value) {
        emit(UpdateCategorySuccess());
      }).catchError((error) {
        emit(UpdateCategoryFailure());
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

  Future<void> captureImage() async {
    emit(UploadImageLoading());
    try {
      final ImagePicker picker = ImagePicker();
      // Capture a photo.
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        emit(UploadImageSuccess(xFile: photo));
      } else {
        emit(UploadImageFailure(error: 'image == null'));
      }
    } catch (e) {
      log(e.toString());
      emit(UploadImageFailure(error: e.toString()));
    }
  }

  Future<void> pickImage() async {
    emit(UploadImageLoading());
    try {
      final ImagePicker picker = ImagePicker();
      // Pick an image.
      final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        emit(UploadImageSuccess(xFile: photo));
      } else {
        emit(UploadImageFailure(error: 'image == null'));
      }
    } catch (e) {
      log(e.toString());
      emit(UploadImageFailure(error: e.toString()));
    }
  }
}
