import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/core/constants.dart';
import 'package:project/core/widgets/awesome_dialog.dart';


import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

import '../../wrestlers_view/Wrestler_view.dart';
import '../../wrestlers_view/cubits/wrestler_cubit/wrestler_cubit.dart';
import '../cubits/category_cubit/category_cubit.dart';
import '../cubits/category_cubit/category_states.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryStates>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Constants.mainColor,
            ),
          );
        } else {
          List categoryList =
              BlocProvider.of<CategoryCubit>(context).categoryList ?? [];
          log('${categoryList.length}');
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              itemCount: categoryList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 5),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<WrestlerCubit>(context).noteList = [];
                    BlocProvider.of<WrestlerCubit>(context)
                        .getCollection(catId: categoryList[index].id);
                    Navigator.pushNamed(context, WrestlerView.id,
                        arguments: [categoryList[index]]);
                  },
                  onLongPress: () {
                    showAwesomeDialog(
                      dismissOnTouchOutside: true,
                      dialogType: DialogType.question,
                      title: 'Choose what do you want',
                      btnOkText: 'Delete',
                      context: context,
                      cancelText: 'Update',
                      cancelFun: () async {
                        await Future.delayed(const Duration(milliseconds: 300));
                        updateCategoryDialog(
                            id: categoryList[index].id,
                            context: context,
                            categoryName: categoryList[index]['name']);
                      },
                      btnOkOnPress: () {
                        BlocProvider.of<CategoryCubit>(context)
                            .deleteCategory(id: categoryList[index].id);
                        categoryList.removeAt(index);
                        setState(() {});
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/folder.png",
                          width: 100,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(categoryList[index]['name']),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  void updateCategoryDialog(
      {required BuildContext context,
      required String categoryName,
      required String id}) {
    AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
    final GlobalKey<FormState> formKey = GlobalKey();
    textEditingController.text = categoryName;
    showDialog(
        context: context,
        builder: (context) {
          return BlocConsumer<CategoryCubit, CategoryStates>(
            listener: (context, state) {
              if (state is UpdateCategorySuccess) {
                BlocProvider.of<CategoryCubit>(context).getCategories();
                Navigator.pop(context);
              } else if (state is AddCategoryFailure) {
                autoValidateMode = AutovalidateMode.always;
                setState(() {});
              }
            },
            builder: (context, state) =>
                AlertDialog(actionsPadding: EdgeInsets.zero, actions: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                    autovalidateMode: autoValidateMode,
                    key: formKey,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: CustomTextField(
                          textEditingController: textEditingController,
                          hintText: textEditingController.text,
                          autofocus: true,
                        ),
                      ),
                      BlocBuilder<CategoryCubit, CategoryStates>(
                        builder: (context, state) => CustomButton(
                          label: 'Save',
                          on: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              BlocProvider.of<CategoryCubit>(context)
                                  .updateCategory(
                                      id: id, name: textEditingController.text);
                            }
                          },
                        ),
                      ),
                    ])),
              ),
            ]),
          );
        });
  }
}