import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/awesome_dialog.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubits/wrestler_cubit/wrestler_cubit.dart';
import '../cubits/wrestler_cubit/wrestler_states.dart';

class WrestlerViewBody extends StatefulWidget {
  const WrestlerViewBody({super.key, this.catId});

  final catId;

  @override
  State<WrestlerViewBody> createState() => _WrestlerViewBodyState();
}

class _WrestlerViewBodyState extends State<WrestlerViewBody> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController followersController = TextEditingController();
  bool loading = false;
  String? loadingNoteId;

  @override
  void dispose() {
    textEditingController.dispose();
    followersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WrestlerCubit, WrestlerStates>(
      listener: (context, state) {
        if (state is UpdateFollowersSuccess) {
          BlocProvider.of<WrestlerCubit>(context)
              .getCollection(catId: widget.catId);
          loadingNoteId = null;
          setState(() {});
        } else if (state is DeleteAllWrestlersSuccess) {
          setState(() {});
        }
      },
      builder: (context, state) {
        if (state is WrestlerLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Constants.mainColor,
            ),
          );
        } else {
          List noteList =
              BlocProvider.of<WrestlerCubit>(context).noteList ?? [];
          log('${noteList.length}');
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                loading = loadingNoteId == noteList[index].id;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    onLongPress: () {
                      showAwesomeDialog(
                        btnOkText: 'Delete',
                        dismissOnTouchOutside: true,
                        dialogType: DialogType.question,
                        title: 'Choose what do you want',
                        context: context,
                        cancelText: 'Update',
                        cancelFun: () async {
                          await Future.delayed(
                              const Duration(milliseconds: 300));
                          updateNoteDialog(
                              id: widget.catId,
                              noteId: noteList[index].id,
                              followersCount: noteList[index]['followers'],
                              context: context,
                              noteName: noteList[index]['name']);
                        },
                        btnOkOnPress: () {
                          BlocProvider.of<WrestlerCubit>(context)
                              .deleteWrestler(
                                  id: widget.catId, noteId: noteList[index].id);
                          noteList.removeAt(index);
                          setState(() {});
                        },
                      );
                    },
                    child: Container(
                      decoration: ShapeDecoration(
                          color: Constants.mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Text(
                            noteList[index]['name'],
                            style: const TextStyle(fontSize: 20),
                          ),
                          const Spacer(),
                          Text(
                            noteList[index]['followers'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  loadingNoteId =
                                      noteList[index].id; // Start loading
                                });
                                BlocProvider.of<WrestlerCubit>(context)
                                    .updateFollowers(
                                        id: widget.catId,
                                        noteId: noteList[index].id,
                                        followers: noteList[index]['followers'],
                                        isFollowedByMe: noteList[index]
                                            ['isFollowedByMe']);
                              },
                              child: loading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                          color: Colors.white))
                                  : Icon(
                                      noteList[index]['isFollowedByMe']
                                          ? FontAwesomeIcons.solidHeart
                                          : FontAwesomeIcons.heart,
                                      color: Colors.white,
                                    )),
                        ],
                      ),
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

  void updateNoteDialog(
      {required BuildContext context,
      required String noteName,
      required String followersCount,
      required String id,
      required String noteId}) {
    AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
    final GlobalKey<FormState> formKey = GlobalKey();
    textEditingController.text = noteName;
    followersController.text = followersCount;
    showDialog(
        context: context,
        builder: (context) {
          return BlocConsumer<WrestlerCubit, WrestlerStates>(
            listener: (context, state) {
              if (state is UpdateWrestlerSuccess) {
                BlocProvider.of<WrestlerCubit>(context)
                    .getCollection(catId: widget.catId);
                Navigator.pop(context);
              } else if (state is AddWrestlerFailure) {
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
                        child: Column(
                          children: [
                            CustomTextField(
                              textEditingController: textEditingController,
                              hintText: textEditingController.text,
                              autofocus: true,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              textEditingController: followersController,
                              hintText: 'Followers count',
                              autofocus: true,
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<WrestlerCubit, WrestlerStates>(
                        builder: (context, state) => CustomButton(
                          label: 'Save',
                          on: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              BlocProvider.of<WrestlerCubit>(context)
                                  .updateWrestler(
                                      followersCount: followersController.text,
                                      noteId: noteId,
                                      id: id,
                                      name: textEditingController.text);
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

// child: ListTile(
//   title: Text(
//     noteList[index]['note'],
//     style: const TextStyle(fontSize: 20),
//   ),
//   trailing: Row(
//     children: [
//       const Text('500'),
//       IconButton(
//           onPressed: () {},
//           icon: const Icon(FontAwesomeIcons.heart)),
//     ],
//   ),
// )
// child: ExpansionTile(
//   iconColor: Colors.white,
//   title: Text(
//     noteList[index]['note'],
//     style: const TextStyle(fontSize: 20),
//   ),
//   shape:
//       const RoundedRectangleBorder(side: BorderSide.none),
//   children: [
//     Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           SizedBox(
//               width:
//                   MediaQuery.of(context).size.width * .5,
//               child: CustomTextField(
//                 textEditingController:
//                     moneyControllers[index],
//               )),
//           const Spacer(),
//           MaterialButton(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             color: Colors.green,
//             onPressed: () {
//               BlocProvider.of<NoteCubit>(context)
//                   .updateMoney(
//                       id: widget.catId,
//                       noteId: noteList[index].id,
//                       money:
//                           moneyControllers[index]!.text);
//               setState(() {});
//             },
//             child: const Text(
//               'Update',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ],
// ),
