abstract class WrestlerStates {}

class WrestlerInitial extends WrestlerStates {}

class AddWrestlerInitial extends WrestlerStates {}

class AddWrestlerSuccess extends WrestlerStates {}

class AddWrestlerLoading extends WrestlerStates {}

class AddWrestlerFailure extends WrestlerStates {}

class WrestlerLoading extends WrestlerStates {}

class WrestlerSuccess extends WrestlerStates {
  List wrestlerList;

  WrestlerSuccess({required this.wrestlerList});
}

class DeleteAllWrestlersSuccess extends WrestlerStates {}

class DeleteAllWrestlersFailure extends WrestlerStates {}

class WrestlerFailure extends WrestlerStates {}

class UpdateWrestlerLoading extends WrestlerStates {}

class UpdateWrestlerSuccess extends WrestlerStates {}

class UpdateWrestlerFailure extends WrestlerStates {}

class UpdateFollowersLoading extends WrestlerStates {}

class UpdateFollowersSuccess extends WrestlerStates {}

class UpdateFollowersFailure extends WrestlerStates {}
