import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubits/category_cubit/category_cubit.dart';
import '../cubits/category_cubit/category_states.dart';

class CustomHomeFloatingActionButton extends StatefulWidget {
  const CustomHomeFloatingActionButton({super.key});

  @override
  State<CustomHomeFloatingActionButton> createState() =>
      _CustomHomeFloatingActionButtonState();
}

class _CustomHomeFloatingActionButtonState
    extends State<CustomHomeFloatingActionButton> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Constants.mainColor,
        shape: const CircleBorder(),
        onPressed: () {
          addCategoryDialog(context);
        },
        child: const Icon(
          Icons.add,
        ));
  }

  void addCategoryDialog(BuildContext context) {
    AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
    final GlobalKey<FormState> formKey = GlobalKey();
    textEditingController.text = '';
    showDialog(
        context: context,
        builder: (context) {
          return BlocConsumer<CategoryCubit, CategoryStates>(
            listener: (context, state) {
              if (state is AddCategorySuccess) {
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
                          hintText: 'Category name',
                          autofocus: true,
                        ),
                      ),
                      BlocBuilder<CategoryCubit, CategoryStates>(
                        builder: (context, state) => CustomButton(
                          label: 'Add',
                          on: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              BlocProvider.of<CategoryCubit>(context)
                                  .addCategory(
                                categoryName: textEditingController.text,
                              );
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
