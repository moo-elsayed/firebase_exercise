import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubits/wrestler_cubit/wrestler_cubit.dart';
import '../cubits/wrestler_cubit/wrestler_states.dart';

class CustomNoteFloatingActionButton extends StatefulWidget {
  const CustomNoteFloatingActionButton(
      {super.key,
      required this.catId,
      required this.textEditingController,
      required this.followersController});

  final String catId;
  final TextEditingController textEditingController;
  final TextEditingController followersController;

  @override
  State<CustomNoteFloatingActionButton> createState() =>
      _CustomNoteFloatingActionButtonState();
}

class _CustomNoteFloatingActionButtonState
    extends State<CustomNoteFloatingActionButton> {
  @override
  void initState() {
    widget.textEditingController.text = '';
    widget.followersController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Constants.mainColor,
        shape: const CircleBorder(),
        onPressed: () {
          addWrestlerDialog(context);
        },
        child: const Icon(
          Icons.add,
        ));
  }

  void addWrestlerDialog(BuildContext context) {
    AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
    final GlobalKey<FormState> formKey = GlobalKey();
    bool isFollowedByMe = false;
    showDialog(
        context: context,
        builder: (context) {
          return BlocConsumer<WrestlerCubit, WrestlerStates>(
            listener: (context, state) {
              if (state is AddWrestlerSuccess) {
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
                    child: StatefulBuilder(
                      builder: (context, setState) => Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: [
                              CustomTextField(
                                textEditingController:
                                    widget.textEditingController,
                                hintText: 'Wrestler name',
                                autofocus: true,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                textEditingController:
                                    widget.followersController,
                                hintText: 'Followers count',
                                autofocus: true,
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<WrestlerCubit, WrestlerStates>(
                          builder: (context, state) => Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  label: isFollowedByMe ? 'Followed' : 'Follow',
                                  on: () {
                                    isFollowedByMe = !isFollowedByMe;
                                    if (isFollowedByMe) {
                                      if (widget.followersController.text
                                          .isNotEmpty) {
                                        int followersCount = int.parse(
                                            widget.followersController.text);
                                        followersCount++;
                                        widget.followersController.text =
                                            followersCount.toString();
                                      } else {
                                        widget.followersController.text = '1';
                                      }
                                    } else {
                                      if (widget.followersController.text
                                          .isNotEmpty) {
                                        int followersCount = int.parse(
                                            widget.followersController.text);
                                        followersCount--;
                                        followersCount == 0
                                            ? widget.followersController.text =
                                                ''
                                            : widget.followersController.text =
                                                followersCount.toString();
                                      }
                                    }
                                    setState(() {});
                                  },
                                  color: isFollowedByMe
                                      ? Colors.green
                                      : Constants.mainColor,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: CustomButton(
                                  label: 'Add',
                                  on: () {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      BlocProvider.of<WrestlerCubit>(context)
                                          .addWrestler(
                                              isFollowedByMe: isFollowedByMe,
                                              catId: widget.catId,
                                              wrestlerName: widget
                                                  .textEditingController.text,
                                              followers: widget
                                                  .followersController.text);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    )),
              ),
            ]),
          );
        });
  }
}
