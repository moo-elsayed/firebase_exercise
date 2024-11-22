import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:project/features/presentation/wrestlers_view/cubits/wrestler_cubit/wrestler_cubit.dart';

import 'custom_note_floating_button.dart';

class CustomExpandableFab extends StatelessWidget {
  const CustomExpandableFab({
    super.key,
    required this.arguments,
  });

  final List arguments;

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      type: ExpandableFabType.up,
      distance: 70,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(
          Icons.keyboard_arrow_up,
          color: Colors.black,
        ),
        fabSize: ExpandableFabSize.regular,
        backgroundColor: const Color(0xffF5F5F7),
        shape: const CircleBorder(),
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.keyboard_arrow_right),
        fabSize: ExpandableFabSize.regular,
        backgroundColor: const Color(0xffF5F5F7),
        shape: const CircleBorder(),
      ),
      children: [
        Row(
          children: [
            const Text('Add'),
            const SizedBox(
              width: 15,
            ),
            CustomNoteFloatingActionButton(
                followersController: TextEditingController(),
                textEditingController: TextEditingController(),
                catId: arguments[0].id),
          ],
        ),
        Row(
          children: [
            const Text('delete all'),
            const SizedBox(width: 10),
            FloatingActionButton(
              shape: const CircleBorder(),
              heroTag: null,
              child: const Icon(Icons.delete),
              onPressed: () {
                BlocProvider.of<WrestlerCubit>(context)
                    .deleteAllWrestlers(id: arguments[0].id);
              },
            ),
          ],
        ),
      ],
    );
  }
}
